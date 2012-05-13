//
//  Created by jansabbe on 1/05/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CalculatorBrainTests.h"
#import "CalculatorBrain.h"


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
    STAssertEqualsWithAccuracy(result, 9., 0.001, nil);
}


- (void)testCalculationsMin {
    [_brain pushOperand:4];
    [_brain pushOperand:5];
    double result = [_brain performOperation:MIN_OPERATOR];
    STAssertEqualsWithAccuracy(result, -1., 0.001, nil);
}


- (void)testCalculationsTimes {
    [_brain pushOperand:4];
    [_brain pushOperand:5];
    double result = [_brain performOperation:TIMES_OPERATOR];
    STAssertEqualsWithAccuracy(result, 20., 0.001, nil);
}


- (void)testCalculationsDivide {
    [_brain pushOperand:4];
    [_brain pushOperand:2];
    double result = [_brain performOperation:DIVIDE_OPERATOR];
    STAssertEqualsWithAccuracy(result, 2., 0.001, nil);
}


- (void)testCalculationsPi {
    double result = [_brain performOperation:PI_OPERATOR];
    STAssertEqualsWithAccuracy(result, 3.1415, 0.001, nil);
}

- (void)testCalculationsSin {
    [_brain performOperation:PI_OPERATOR];
    [_brain pushOperand:2];
    [_brain performOperation:DIVIDE_OPERATOR];
    double result = [_brain performOperation:SIN_OPERATOR];
    STAssertEqualsWithAccuracy(result, 1., 0.001, nil);
}

- (void)testCalculationsCos {
    [_brain pushOperand:0];
    double result = [_brain performOperation:COS_OPERATOR];
    STAssertEqualsWithAccuracy(result, 1., 0.001, nil);
}

- (void)testCalculationsSqrt {
    [_brain pushOperand:4];
    double result = [_brain performOperation:SQRT_OPERATOR];
    STAssertEqualsWithAccuracy(result, 2., 0.001, nil);
}

- (void)testResultIsAddedAsNewOperand {
    [_brain pushOperand:1];
    [_brain pushOperand:1];
    [_brain performOperation:PLUS_OPERATOR];
    [_brain pushOperand:2];
    double result = [_brain performOperation:PLUS_OPERATOR];
    STAssertEqualsWithAccuracy(result, 4., 0.001, nil);
}

- (void)testResultIsZeroIfNoOperands {
    double result = [_brain performOperation:PLUS_OPERATOR];
    STAssertEqualsWithAccuracy(result, 0., 0.001, nil);
}

- (void)testResultIsZeroIfDividingByZero {
    [_brain pushOperand:1];
    [_brain pushOperand:0];
    double result = [_brain performOperation:DIVIDE_OPERATOR];
    STAssertEqualsWithAccuracy(result, 0., 0.001, nil);
}

@end