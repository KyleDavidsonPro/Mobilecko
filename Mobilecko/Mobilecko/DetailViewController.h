//
//  DetailViewController.h
//  Mobilecko
//
//  Created by Kyle Davidson on 09/11/2013.
//  Copyright (c) 2013 Kyle Davidson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
