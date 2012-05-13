//
//  Created by jansabbe on 1/05/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property(strong, nonatomic) NSMutableArray *stack;
@end

@implementation CalculatorBrain
@synthesize stack = _stack;


- (void)pushOperand:(double)operand {
    [self.stack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation {
    double result = [self calculateOperation:operation];
    [self pushOperand:result];
    return result;
}

- (double)popOperand {
    double operand = [[self.stack lastObject] doubleValue];
    [self.stack removeLastObject];
    return operand;
}

- (NSMutableArray *)stack {
    if (_stack == nil) {
        _stack = [[NSMutableArray alloc] init];
    }
    return _stack;
}

- (double)calculateOperation:(NSString *)operation {
    double result = 0;

    if ([PLUS_OPERATOR isEqualToString:operation]) {
        result = [self popOperand] + [self popOperand];
    } else if ([MIN_OPERATOR isEqualToString:operation]) {
        double subtracted = [self popOperand];
        result = [self popOperand] - subtracted;
    } else if ([TIMES_OPERATOR isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if ([DIVIDE_OPERATOR isEqualToString:operation]) {
        double divisor = [self popOperand];
        if (divisor != 0) {
            result = [self popOperand] / divisor;
        }
    } else if ([PI_OPERATOR isEqualToString:operation]) {
        result = M_PI;
    } else if ([COS_OPERATOR isEqualToString:operation]) {
        result = cos([self popOperand]);
    } else if ([SIN_OPERATOR isEqualToString:operation]) {
        result = sin([self popOperand]);
    } else if ([SQRT_OPERATOR isEqualToString:operation]) {
        result = sqrt([self popOperand]);
    }
    return result;
}


@end