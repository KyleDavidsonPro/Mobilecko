//
//  EventDetailViewController.h
//  Mobilecko
//
//  Created by Kyle Davidson on 03/02/2014.
//  Copyright (c) 2014 Kyle Davidson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailViewController : UIViewController

@property(nonatomic, strong) Event *event;

@property(nonatomic, strong)IBOutlet UILabel *name;
@property(nonatomic, strong)IBOutlet UILabel *address;
@property(nonatomic, strong)IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UISegmentedControl *attendSeg;
- (IBAction)eventAttend;
- (IBAction)segmentChanged:(id)sender;
@end
