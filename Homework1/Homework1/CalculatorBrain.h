//
//  Created by jansabbe on 1/05/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


static NSString *const PLUS_OPERATOR = @"+";
static NSString *const MIN_OPERATOR = @"-";
static NSString *const TIMES_OPERATOR = @"*";
static NSString *const DIVIDE_OPERATOR = @"/";
static NSString *const PI_OPERATOR = @"π";
static NSString *const SIN_OPERATOR = @"sin";
static NSString *const COS_OPERATOR = @"cos";
static NSString *const SQRT_OPERATOR = @"sqrt";


@interface CalculatorBrain : NSObject
- (void)pushOperand:(double)operand;
- (void)pushVariable:(NSString*) variable;

- (double)performOperation:(NSString *)string;

@property (readonly) id program;
+ (double)runProgram:(id) program;
+ (double)runProgram:(id) program
      usingVariables:(NSDictionary*) variableValues;
+ (NSString*) descriptionOfProgram:(id)program;

+ (NSSet *)variablesUsedInProgram:(id)o;
@end