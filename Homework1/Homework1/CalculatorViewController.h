//
//  CalculatorViewController.h
//  Homework1
//
//  Created by Jan Sabbe on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

static int const MAX_LENGTH_CALCULATIONLABEL = 35;
static NSString *const DECIMAL_SEPARATOR = @".";

@protocol SplitButtonPresenter <NSObject>
- (void) showSplitButton:(UIBarButtonItem*) barButton;
- (void) hideSplitButton;
@end

@interface CalculatorViewController : UIViewController<UISplitViewControllerDelegate>
@property(weak, nonatomic) IBOutlet UILabel *resultLabel;
@property(weak, nonatomic) IBOutlet UILabel *calculationLabel;

@end