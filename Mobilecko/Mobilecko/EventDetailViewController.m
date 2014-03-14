//
//  EventDetailViewController.m
//  Mobilecko
//
//  Created by Kyle Davidson on 03/02/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import "EventDetailViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoggedInUser.h"
@interface EventDetailViewController ()

@end

@implementation EventDetailViewController
@synthesize event;
@synthesize name,address,date;
@synthesize attendBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    name.text = event.name;
    address.text = event.address;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *stringFromDate = [formatter stringFromDate:event.date];
    
    date.text = stringFromDate;
    
    if (![[LoggedInUser sharedUser] currentUser]) {
        [self.attendBtn setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)eventAttend {
    // Check if the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:nil]) {
        // Present the share dialog
        [FBDialogs presentShareDialogWithLink:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              NSLog(@"Error: %@", error.description);
                                          } else {
                                              NSLog(@"Success!");
                                          }
                                      }];
    } else {
        
    }
    
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
