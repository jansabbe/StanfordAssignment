//
//  CalculatorViewController.m
//  Homework1
//
//  Created by Jan Sabbe on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController ()
@property(nonatomic) BOOL isEnteringNewNumber;
@property(nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clearPressed];
}

- (void)viewDidUnload {
    [self setResultLabel:nil];
    [self setBrain:nil];
    [self setCalculationLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

# pragma mark - Button presses

- (IBAction)enterPressed {
    NSString *numberEnteredByUserAsString = self.resultLabel.text;
    [self.brain pushOperand:[numberEnteredByUserAsString doubleValue]];
    self.isEnteringNewNumber = YES;
    [self updateLabels];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (!self.isEnteringNewNumber) {
        [self enterPressed];
    }
    NSString *operation = sender.currentTitle;
    [self.brain performOperation:operation];
    [self updateLabels];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.isEnteringNewNumber) {
        self.resultLabel.text = digit;
        self.isEnteringNewNumber = NO;
    } else {
        [self appendToResultLabel:digit];
    }
}

- (IBAction)decimalPointPressed {
    if (self.isEnteringNewNumber) {
        self.resultLabel.text = @"0.";
        self.isEnteringNewNumber = NO;
    } else if ([self.resultLabel.text rangeOfString:DECIMAL_SEPARATOR].location == NSNotFound) {
        [self appendToResultLabel:DECIMAL_SEPARATOR];
    }
}

- (IBAction)clearPressed {
    self.isEnteringNewNumber = YES;
    self.brain = [[CalculatorBrain alloc] init];
    [self updateLabels];
}

- (IBAction)variablePressed:(UIButton*)sender {
    [self.brain pushVariable: sender.currentTitle];
    [self updateLabels];
}

#pragma mark - Update labels

- (void)appendToResultLabel:(NSString *)suffix {
    self.resultLabel.text = [self.resultLabel.text stringByAppendingString:suffix];
}

- (void)updateLabels {
    self.calculationLabel.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    double result = [CalculatorBrain runProgram:self.brain.program];
    self.resultLabel.text = [NSString stringWithFormat:@"%g", result];
}

#pragma mark - Segue stuff

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowGraph"]) {
        [segue.destinationViewController setCalculatorProgram:self.brain.program];
    }
}

@end