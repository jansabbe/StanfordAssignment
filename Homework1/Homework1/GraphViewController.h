//
//  GraphViewController.h
//  Homework1
//
//  Created by Jan Sabbe on 3/01/13.
//
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *descriptionProgram;
@property (strong,nonatomic) id calculatorProgram;
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@end
