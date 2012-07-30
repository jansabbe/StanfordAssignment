//
//  Created by jansabbe on 1/05/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property(strong, nonatomic) NSMutableArray *programStack;
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;


- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

+ (NSString*) descriptionOfProgram:(id)program {
    return nil;
}

+ (double) runProgram:(id)program {
    NSMutableArray* stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double) popOperandOffStack:(NSMutableArray*)stack {
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString* operation = topOfStack;
        if ([PLUS_OPERATOR isEqualToString:operation]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([MIN_OPERATOR isEqualToString:operation]) {
            double subtracted = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtracted;
        } else if ([TIMES_OPERATOR isEqualToString:operation]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([DIVIDE_OPERATOR isEqualToString:operation]) {
            double divisor = [self popOperandOffStack:stack];
            if (divisor != 0) {
                result = [self popOperandOffStack:stack] / divisor;
            }
        } else if ([PI_OPERATOR isEqualToString:operation]) {
            result = M_PI;
        } else if ([COS_OPERATOR isEqualToString:operation]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([SIN_OPERATOR isEqualToString:operation]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([SQRT_OPERATOR isEqualToString:operation]) {
            result = sqrt([self popOperandOffStack:stack]);
        }
    }
    
    return result;
}

- (id) program {
    return [self.programStack copy];
}

- (NSMutableArray *)programStack {
    if (_programStack == nil) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}


@end