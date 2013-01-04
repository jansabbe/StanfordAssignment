//
//  GraphViewController.m
//  Homework1
//
//  Created by Jan Sabbe on 3/01/13.
//
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"

static NSString* const USER_PREFERENCE_KEY = @"graphView";

@interface GraphViewController()<GraphViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation GraphViewController

- (void)viewDidLoad {
    self.descriptionProgram.text = [CalculatorBrain descriptionOfProgram:self.calculatorProgram];
    self.graphView.delegate = self;
    UIPinchGestureRecognizer* pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(pinch:)];
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(pan:)];
    panRecognizer.delegate = self;
    [self.graphView addGestureRecognizer:pinchRecognizer];
    [self.graphView addGestureRecognizer:panRecognizer];
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(tap:)];
    tapRecognizer.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tapRecognizer];
    [self loadGraphViewSettings];
}

- (void) setCalculatorProgram:(id)calculatorProgram {
    _calculatorProgram = calculatorProgram;
    [self.graphView setNeedsDisplay];
}

- (double) giveYForX:(double)x inView:(GraphView *)view {
    return [CalculatorBrain runProgram:self.calculatorProgram
                        usingVariables: @{@"x" : @(x)}];
}

#pragma mark - Setting up bar button item

- (void) showSplitButton:(UIBarButtonItem *)barButton {
    self.toolbar.items = @[barButton];
}

- (void) hideSplitButton {
    self.toolbar.items = @[];
}

#pragma mark - Gestures

- (void) pinch:(UIPinchGestureRecognizer*) pinchRecognizer {
    if (pinchRecognizer.state == UIGestureRecognizerStateChanged ||
        pinchRecognizer.state == UIGestureRecognizerStateEnded) {
        self.graphView.scale *= pinchRecognizer.scale;
        pinchRecognizer.scale = 1;
        [self saveGraphViewSettings];
    }
}

- (void) pan:(UIPanGestureRecognizer*) panRecognizer {
    if (panRecognizer.state == UIGestureRecognizerStateChanged ||
        panRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [panRecognizer translationInView:self.graphView];
        self.graphView.origin = CGPointMake(self.graphView.origin.x + translation.x, self.graphView.origin.y + translation.y);
        [panRecognizer setTranslation:CGPointZero inView:self.graphView];
        [self saveGraphViewSettings];
    }
}

- (void) tap:(UITapGestureRecognizer*) tapRecognizer {
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        self.graphView.origin = [tapRecognizer locationInView:self.graphView];
        [self saveGraphViewSettings];
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Saving user prefs

- (void) saveGraphViewSettings {
    [[NSUserDefaults standardUserDefaults] setObject:@{
     @"origin": @{
        @"x": @(self.graphView.origin.x),
        @"y": @(self.graphView.origin.y)},
     @"scale": @(self.graphView.scale)}
                                              forKey:USER_PREFERENCE_KEY];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) loadGraphViewSettings {
    NSDictionary* settings = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PREFERENCE_KEY];
    if (settings) {
        NSNumber* origin_x = settings[@"origin"][@"x"];
        NSNumber* origin_y = settings[@"origin"][@"y"];
        NSNumber* scale = settings[@"scale"];
        
        self.graphView.origin = CGPointMake(origin_x.floatValue, origin_y.floatValue);
        self.graphView.scale = scale.floatValue;
    }
}


@end
