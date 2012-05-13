//
//  CalculatorViewController.m
//  Homework1
//
//  Created by Jan Sabbe on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property(nonatomic) BOOL isEnteringNewNumber;
@property(nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize resultLabel = _resultLabel;
@synthesize calculationLabel = _calculationLabel;
@synthesize isEnteringNewNumber = _isEnteringNewNumber;
@synthesize brain = _brain;

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

- (IBAction)enterPressed {
    NSString *numberEnteredByUserAsString = self.resultLabel.text;
    [self.brain pushOperand:[numberEnteredByUserAsString doubleValue]];
    [self appendToCalculationLabel:numberEnteredByUserAsString];
    self.isEnteringNewNumber = YES;
}


- (IBAction)operationPressed:(UIButton *)sender {
    if (!self.isEnteringNewNumber) {
        [self enterPressed];
    }
    NSString *operation = sender.currentTitle;
    double result = [self.brain performOperation:operation];
    self.resultLabel.text = [NSString stringWithFormat:@"%g", result];
    [self appendToCalculationLabel:[NSString stringWithFormat:@"%@ =", operation]];
}

- (IBAction)digitPressed:(UIButton *)sender {
    [self removeExistingEqualsFromCalculationLabel];

    NSString *digit = sender.currentTitle;
    if (self.isEnteringNewNumber) {
        self.resultLabel.text = digit;
        self.isEnteringNewNumber = NO;
    } else {
        [self appendToResultLabel:digit];
    }
}

- (IBAction)decimalPointPressed {
    [self removeExistingEqualsFromCalculationLabel];

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
    self.resultLabel.text = @"0";
    self.calculationLabel.text = @"";
}

- (void)appendToResultLabel:(NSString *)suffix {
    self.resultLabel.text = [self.resultLabel.text stringByAppendingString:suffix];
}

- (void)appendToCalculationLabel:(NSString *)suffix {
    [self removeExistingEqualsFromCalculationLabel];
    self.calculationLabel.text = [self.calculationLabel.text stringByAppendingFormat:@" %@", suffix];
    if (([self.calculationLabel.text length]) > MAX_LENGTH_CALCULATIONLABEL) {
        self.calculationLabel.text = [self.calculationLabel.text substringFromIndex:(([self.calculationLabel.text length]) - MAX_LENGTH_CALCULATIONLABEL)];
    }
}

- (void)removeExistingEqualsFromCalculationLabel {
    self.calculationLabel.text = [self.calculationLabel.text stringByReplacingOccurrencesOfString:@" =" withString:@""];
}

@end