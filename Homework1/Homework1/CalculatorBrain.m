//
//  Created by jansabbe on 1/05/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property(strong, nonatomic) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable {
    if ([CalculatorBrain isVariable:variable]) {
        [self.programStack addObject:variable];
    }
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

+ (NSString *)descriptionOfOperandOffStack:(NSMutableArray *)stack {
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }
    NSString *description;
    if ([self isOperand:topOfStack] || [self isVariable:topOfStack] || [self isNoParamOperator:topOfStack]) {
        description = [NSString stringWithFormat:@"%@", topOfStack];
    } else if ([self isOneParamOperator:topOfStack]) {
        description = [NSString stringWithFormat:@"%@(%@)", topOfStack, [self descriptionOfOperandOffStack:stack]];
    } else if ([self isTwoParamOperator:topOfStack]) {
        NSString *lastPart = [self addParenthesesIfOperator: topOfStack hasHigherPrecedenceThanAnOperatorIn:[self descriptionOfOperandOffStack:stack]];
        NSString *firstPart = [self addParenthesesIfOperator: topOfStack hasHigherPrecedenceThanAnOperatorIn:[self descriptionOfOperandOffStack:stack]];
        description = [NSString stringWithFormat:@"%@ %@ %@", firstPart, topOfStack, lastPart];
    }

    return description;
}

+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }

    NSMutableArray *expressions = [[NSMutableArray alloc] init];
    while([stack count] > 0) {
        [expressions insertObject:[self descriptionOfOperandOffStack:stack] atIndex:0];
    }
    return [expressions componentsJoinedByString:@", "];
}

+ (double)runProgram:(id)program usingVariables:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack usingVariables:variableValues];
}


+ (double)runProgram:(id)program {
    return [self runProgram:program usingVariables:nil];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
              usingVariables:(NSDictionary *)variableValues {
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }

    if ([self isOperand:topOfStack]) {
        result = [topOfStack doubleValue];
    } else if ([self isOperator:topOfStack]) {
        result = [self performOperation:stack usingVariables:variableValues operation:topOfStack];
    } else if ([self isVariable:topOfStack]) {
        result = [[variableValues objectForKey:topOfStack] doubleValue];
    }

    return result;
}

+ (double)performOperation:(NSMutableArray *)stack usingVariables:(NSDictionary *)variableValues operation:(NSString *)operation {
    double operationResult = 0;
    if ([PLUS_OPERATOR isEqualToString:operation]) {
        operationResult = [self popOperandOffStack:stack usingVariables:variableValues] + [self popOperandOffStack:stack usingVariables:variableValues];
    } else if ([MIN_OPERATOR isEqualToString:operation]) {
        double subtracted = [self popOperandOffStack:stack usingVariables:variableValues];
        operationResult = [self popOperandOffStack:stack usingVariables:variableValues] - subtracted;
    } else if ([TIMES_OPERATOR isEqualToString:operation]) {
        operationResult = [self popOperandOffStack:stack usingVariables:variableValues] * [self popOperandOffStack:stack usingVariables:variableValues];
    } else if ([DIVIDE_OPERATOR isEqualToString:operation]) {
        double divisor = [self popOperandOffStack:stack usingVariables:variableValues];
        if (divisor != 0) {
            operationResult = [self popOperandOffStack:stack usingVariables:variableValues] / divisor;
        }
    } else if ([PI_OPERATOR isEqualToString:operation]) {
        operationResult = M_PI;
    } else if ([COS_OPERATOR isEqualToString:operation]) {
        operationResult = cos([self popOperandOffStack:stack usingVariables:variableValues]);
    } else if ([SIN_OPERATOR isEqualToString:operation]) {
        operationResult = sin([self popOperandOffStack:stack usingVariables:variableValues]);
    } else if ([SQRT_OPERATOR isEqualToString:operation]) {
        operationResult = sqrt([self popOperandOffStack:stack usingVariables:variableValues]);
    }
    return operationResult;
}

- (id)program {
    return [self.programStack copy];
}

- (NSMutableArray *)programStack {
    if (_programStack == nil) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

+ (NSSet *)allowedOperators {
    return [NSSet setWithObjects:PLUS_OPERATOR, MIN_OPERATOR, TIMES_OPERATOR, DIVIDE_OPERATOR, PI_OPERATOR, SIN_OPERATOR, COS_OPERATOR, SQRT_OPERATOR, nil];
}

+ (BOOL)isOperator:(id)term {
    return [term isKindOfClass:[NSString class]] && [[self allowedOperators] containsObject:term];
}

+ (BOOL)isNoParamOperator:(id)term {
    NSSet *noParamOperators = [NSSet setWithObject:PI_OPERATOR];
    return [term isKindOfClass:[NSString class]] && [noParamOperators containsObject:term];
}

+ (BOOL)isOneParamOperator:(id)term {
    NSSet *oneParamOperators = [NSSet setWithObjects:SIN_OPERATOR, COS_OPERATOR, SQRT_OPERATOR, nil];
    return [term isKindOfClass:[NSString class]] && [oneParamOperators containsObject:term];
}

+ (BOOL)isTwoParamOperator:(id)term {
    NSSet *twoParamOperators = [NSSet setWithObjects:PLUS_OPERATOR, MIN_OPERATOR, TIMES_OPERATOR, DIVIDE_OPERATOR, nil];
    return [term isKindOfClass:[NSString class]] && [twoParamOperators containsObject:term];
}

+ (BOOL)isOperand:(id)term {
    return [term isKindOfClass:[NSNumber class]];
}

+ (BOOL)isVariable:(id)term {
    return [term isKindOfClass:[NSString class]] && ![[self allowedOperators] containsObject:term];
}

+ (NSString *)addParenthesesIfOperator:(NSString *)operator hasHigherPrecedenceThanAnOperatorIn:(NSString *)expression {
    if ([self shouldAddParenthesesForOperator:operator whenExpression:expression]) {
        return [NSString stringWithFormat:@"(%@)", expression];
    }
    return expression;
}

+ (BOOL) shouldAddParenthesesForOperator:(NSString*) operator whenExpression:(NSString*) expression {
    
    if ([operator isEqualToString:PLUS_OPERATOR]) {
        return NO;
    }
    if ([operator isEqualToString:MIN_OPERATOR]) {
        return NO;
    }
    if ([expression length] == 1) {
        return NO;
    }
    return YES;
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSArray *programStack;
    if ([program isKindOfClass:[NSArray class]]) {
        programStack = program;
    }

    NSMutableSet *variablesUsed = [[NSMutableSet alloc] init];
    for (id term in programStack) {
        if ([self isVariable:term]) {
            [variablesUsed addObject:term];
        }
    }
    return [variablesUsed count] != 0 ? variablesUsed : nil;
}
@end