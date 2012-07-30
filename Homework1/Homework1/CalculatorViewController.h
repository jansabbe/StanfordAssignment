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

@interface CalculatorViewController : UIViewController
@property(weak, nonatomic) IBOutlet UILabel *resultLabel;
@property(weak, nonatomic) IBOutlet UILabel *calculationLabel;
@property (weak, nonatomic) IBOutlet UILabel *variableValuesLabel;

@end