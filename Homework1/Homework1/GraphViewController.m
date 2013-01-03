//
//  GraphViewController.m
//  Homework1
//
//  Created by Jan Sabbe on 3/01/13.
//
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"

@interface GraphViewController()<GraphViewDataSource>

@end

@implementation GraphViewController

- (void)viewDidLoad {
    self.descriptionProgram.text = [CalculatorBrain descriptionOfProgram:self.calculatorProgram];
    self.graphView.delegate = self;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView
                                                                                   action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView
                                                                                   action:@selector(pan:)]];
}

- (double) giveYForX:(double)x inView:(GraphView *)view {
    return [CalculatorBrain runProgram:self.calculatorProgram
                        usingVariables: @{@"x" : @(x)}];
}

@end
