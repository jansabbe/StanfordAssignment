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
@property(nonatomic, strong) NSDictionary* variableValues;
@end

@implementation CalculatorViewController
@synthesize resultLabel = _resultLabel;
@synthesize calculationLabel = _calculationLabel;
@synthesize variableValuesLabel = _variableValuesLabel;
@synthesize isEnteringNewNumber = _isEnteringNewNumber;
@synthesize brain = _brain;
@synthesize variableValues = _variableValues;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clearPressed];
}

- (void)viewDidUnload {
    [self setResultLabel:nil];
    [self setBrain:nil];
    [self setCalculationLabel:nil];
    [self setVariableValuesLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

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

- (IBAction)setupVariable1 {
    self.variableValues = [NSDictionary dictionaryWithObjectsAndKeys:   [NSNumber numberWithInt:3], @"x",
        [NSNumber numberWithInt:4], @"y",
        [NSNumber numberWithDouble:2.3], @"a",
        [NSNumber numberWithDouble:-5], @"b",
                           nil];
    [self updateLabels];
}

- (IBAction)setupVariable2 {
    self.variableValues = [NSDictionary dictionaryWithObjectsAndKeys:   [NSNumber numberWithInt:1], @"x",
        [NSNumber numberWithInt:0], @"y",
        [NSNumber numberWithDouble:-1], @"a",
        [NSNumber numberWithDouble:2], @"b",
                           nil];
    [self updateLabels];
}

- (IBAction)setupVariable3 {
    self.variableValues = nil;
    [self updateLabels];
}

- (void)appendToResultLabel:(NSString *)suffix {
    self.resultLabel.text = [self.resultLabel.text stringByAppendingString:suffix];
}

- (void)updateLabels {
    self.calculationLabel.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    double result = [CalculatorBrain runProgram:self.brain.program
                                 usingVariables:self.variableValues];
    self.resultLabel.text = [NSString stringWithFormat:@"%g", result];
    
    NSMutableArray* variableValuesTexts = [[NSMutableArray alloc] init];
    for (NSString* usedVariable in [CalculatorBrain variablesUsedInProgram:self.brain.program]) {
        [variableValuesTexts addObject:[NSString stringWithFormat:@"%@ = %g", usedVariable, [[self.variableValues objectForKey:usedVariable] doubleValue]]];
    }
    self.variableValuesLabel.text = [variableValuesTexts componentsJoinedByString:@", "];

}


@end