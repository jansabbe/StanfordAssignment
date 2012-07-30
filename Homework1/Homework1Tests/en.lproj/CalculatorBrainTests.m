//
//  Created by jansabbe on 1/05/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CalculatorBrainTests.h"
#import "CalculatorBrain.h"

#define PRECISION 0.001

@implementation CalculatorBrainTests {
    CalculatorBrain *_brain;
}

- (void)setUp {
    [super setUp];
    _brain = [[CalculatorBrain alloc] init];
}

- (void)testCalculationsPlus {
    [_brain pushOperand:4];
    [_brain pushOperand:5];
    double result = [_brain performOperation:PLUS_OPERATOR];
    STAssertEqualsWithAccuracy(result, 9., PRECISION, nil);
}


- (void)testCalculationsMin {
    [_brain pushOperand:4];
    [_brain pushOperand:5];
    double result = [_brain performOperation:MIN_OPERATOR];
    STAssertEqualsWithAccuracy(result, -1., PRECISION, nil);
}


- (void)testCalculationsTimes {
    [_brain pushOperand:4];
    [_brain pushOperand:5];
    double result = [_brain performOperation:TIMES_OPERATOR];
    STAssertEqualsWithAccuracy(result, 20., PRECISION, nil);
}


- (void)testCalculationsDivide {
    [_brain pushOperand:4];
    [_brain pushOperand:2];
    double result = [_brain performOperation:DIVIDE_OPERATOR];
    STAssertEqualsWithAccuracy(result, 2., PRECISION, nil);
}


- (void)testCalculationsPi {
    double result = [_brain performOperation:PI_OPERATOR];
    STAssertEqualsWithAccuracy(result, 3.1415, PRECISION, nil);
}

- (void)testCalculationsSin {
    [_brain performOperation:PI_OPERATOR];
    [_brain pushOperand:2];
    [_brain performOperation:DIVIDE_OPERATOR];
    double result = [_brain performOperation:SIN_OPERATOR];
    STAssertEqualsWithAccuracy(result, 1., PRECISION, nil);
}

- (void)testCalculationsCos {
    [_brain pushOperand:0];
    double result = [_brain performOperation:COS_OPERATOR];
    STAssertEqualsWithAccuracy(result, 1., PRECISION, nil);
}

- (void)testCalculationsSqrt {
    [_brain pushOperand:4];
    double result = [_brain performOperation:SQRT_OPERATOR];
    STAssertEqualsWithAccuracy(result, 2., PRECISION, nil);
}

- (void)testResultIsAddedAsNewOperand {
    [_brain pushOperand:1];
    [_brain pushOperand:1];
    [_brain performOperation:PLUS_OPERATOR];
    [_brain pushOperand:2];
    double result = [_brain performOperation:PLUS_OPERATOR];
    STAssertEqualsWithAccuracy(result, 4., PRECISION, nil);
}

- (void)testResultIsZeroIfNoOperands {
    double result = [_brain performOperation:PLUS_OPERATOR];
    STAssertEqualsWithAccuracy(result, 0., PRECISION, nil);
}

- (void)testResultIsZeroIfDividingByZero {
    [_brain pushOperand:1];
    [_brain pushOperand:0];
    double result = [_brain performOperation:DIVIDE_OPERATOR];
    STAssertEqualsWithAccuracy(result, 0., PRECISION, nil);
}

- (void)testAddingAVariableWithoutSpecifyingAValueWillAssumeZero {
    [_brain pushOperand:1];
    [_brain pushVariable:@"x"];
    double result = [_brain performOperation:PLUS_OPERATOR];
    STAssertEqualsWithAccuracy(result, 1., PRECISION, nil);
}

- (void)testAddingAVariableWithSpecifyingAValueWillUseThatValue {
    [_brain pushOperand:1];
    [_brain pushVariable:@"x"];

    NSDictionary *variables = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:9] forKey:@"x"];

    [_brain performOperation:PLUS_OPERATOR];
    double result = [CalculatorBrain runProgram:_brain.program
                                 usingVariables:variables];

    STAssertEqualsWithAccuracy(result, 10., PRECISION, nil);
}


- (void)testUsingAnUndefinedVariableWillAsumeZero {
    [_brain pushOperand:1];
    [_brain pushVariable:@"yyyyy"];

    NSDictionary *variables = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:9] forKey:@"x"];

    [_brain performOperation:PLUS_OPERATOR];
    double result = [CalculatorBrain runProgram:_brain.program
                                 usingVariables:variables];

    STAssertEqualsWithAccuracy(result, 1., PRECISION, nil);
}

- (void)testVariablesUsedInProgram {
    [_brain pushOperand:1];
    [_brain pushVariable:@"x"];
    [_brain performOperation:PLUS_OPERATOR];
    [_brain pushVariable:@"y"];
    [_brain performOperation:MIN_OPERATOR];
    [_brain pushVariable:@"x"];
    [_brain performOperation:PLUS_OPERATOR];

    NSSet *variables = [CalculatorBrain variablesUsedInProgram:_brain.program];

    STAssertEquals(2u, [variables count], nil);
    STAssertTrue([variables containsObject:@"x"], nil);
    STAssertTrue([variables containsObject:@"y"], nil);
}

- (void)testVariablesUsedInProgramPassingNilReturnsNil {
    NSSet *variables = [CalculatorBrain variablesUsedInProgram:nil];

    STAssertNil(variables, nil);
}


- (void)testVariablesUsedInProgramNoVariablesUsedReturnsNil {
    [_brain pushOperand:1];
    [_brain pushOperand:1];
    [_brain performOperation:PLUS_OPERATOR];

    NSSet *variables = [CalculatorBrain variablesUsedInProgram:_brain.program];

    STAssertNil(variables, nil);
}

- (void)testDescriptionOfProgramSingleValue {
    [_brain pushOperand:1];

    STAssertEqualObjects(@"1", [CalculatorBrain descriptionOfProgram:_brain.program], nil);
}

- (void)testDescriptionOfProgramSingleVariable {
    [_brain pushVariable:@"x"];

    STAssertEqualObjects(@"x", [CalculatorBrain descriptionOfProgram:_brain.program], nil);
}


- (void)testDescriptionOfProgramNoParamsOperator {
    [_brain performOperation:PI_OPERATOR];

    STAssertEqualObjects(PI_OPERATOR, [CalculatorBrain descriptionOfProgram:_brain.program], nil);
}

- (void)testDescriptionOfProgramSingleOperand {
    [_brain pushOperand:1];
    [_brain performOperation:SIN_OPERATOR];

    STAssertEqualObjects(@"sin(1)", [CalculatorBrain descriptionOfProgram:_brain.program], nil);
}


- (void)testDescriptionOfProgramMultiParamOperand {
    [_brain pushOperand:1];
    [_brain pushOperand:2];
    [_brain performOperation:PLUS_OPERATOR];

    STAssertEqualObjects(@"1 + 2", [CalculatorBrain descriptionOfProgram:_brain.program], nil);
}


- (void)testDescriptionOfProgramMultipleOperands {
    [_brain pushOperand:1];
    [_brain pushOperand:2];
    [_brain performOperation:PLUS_OPERATOR];
    [_brain pushVariable:@"x"];
    [_brain performOperation:MIN_OPERATOR];

    STAssertEqualObjects(@"1 + 2 - x", [CalculatorBrain descriptionOfProgram:_brain.program], nil);
}

- (void)testDescriptionOfProgramMultipleOperandsWithDifferentPrecedence {
    [_brain pushOperand:1];
    [_brain pushOperand:2];
    [_brain performOperation:PLUS_OPERATOR];
    [_brain pushVariable:@"x"];
    [_brain pushVariable:@"y"];
    [_brain performOperation:MIN_OPERATOR];
    [_brain performOperation:TIMES_OPERATOR];

    STAssertEqualObjects(@"(1 + 2) * (x - y)", [CalculatorBrain descriptionOfProgram:_brain.program], nil);
}

- (void)testDescriptionOfProgramDivideOperator {
    [_brain pushOperand:1];
    [_brain pushOperand:2];
    [_brain pushOperand:3];
    [_brain performOperation:TIMES_OPERATOR];
    [_brain performOperation:DIVIDE_OPERATOR];
    
    STAssertEqualObjects(@"1 / (2 * 3)", [CalculatorBrain descriptionOfProgram:_brain.program], nil);
}

- (void)testDoesntAddParenthesesIfNotNeededEvenWithDifferentPrecedenceRules {
    //a a * b b * + sqrt (from assignment)
    [_brain pushVariable:@"a"];
    [_brain pushVariable:@"a"];
    [_brain performOperation:TIMES_OPERATOR];
    [_brain pushVariable:@"b"];
    [_brain pushVariable:@"b"];
    [_brain performOperation:TIMES_OPERATOR];
    [_brain performOperation:PLUS_OPERATOR];
    [_brain performOperation:SQRT_OPERATOR];

    STAssertEqualObjects(@"sqrt(a * a + b * b)", [CalculatorBrain descriptionOfProgram:_brain.program], nil);
}

- (void)testSeperatesDifferentExpressionsUsingAComma {
    //a a * b b * + sqrt (from assignment)
    [_brain pushVariable:@"a"];
    [_brain pushVariable:@"b"];
    [_brain performOperation:TIMES_OPERATOR];
    [_brain pushVariable:@"c"];
    [_brain pushOperand:5];

    STAssertEqualObjects(@"a * b, c, 5", [CalculatorBrain descriptionOfProgram:_brain.program], nil);
}

@end