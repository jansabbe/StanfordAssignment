//
//  GraphView.m
//  Homework1
//
//  Created by Jan Sabbe on 3/01/13.
//
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

#pragma mark - Initialisation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) awakeFromNib {
    [self setup];
}

- (void) setup {
    self.origin = [self middlePoint];
    self.scale = 1;
}

#pragma mark - Drawing rect

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];

    
    
    [[UIColor blueColor] setStroke];
	CGContextBeginPath(context);

    double minimumX = -self.origin.x/self.scale;
    double maximumX = minimumX + rect.size.width/self.scale;
    double y = [self.delegate giveYForX:minimumX inView:self];
    CGContextMoveToPoint(context, minimumX, y);
    
    for (double x = minimumX; x <= maximumX; x+=1/self.scale) {
        double y = [self.delegate giveYForX:x inView:self];
        CGContextAddLineToPoint(context, self.origin.x + (x * self.scale),
                                self.origin.y + (y * -self.scale));
    }
    
	CGContextStrokePath(context);
}


#pragma mark - Utility methods

- (CGPoint) middlePoint {
    return CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2,
                       self.bounds.origin.y + self.bounds.size.height / 2);
}

- (void) setScale:(CGFloat)scale {
    _scale = scale;
    [self setNeedsDisplay];
}

- (void) setOrigin:(CGPoint)origin {
    _origin = origin;
    [self setNeedsDisplay];
}

#pragma mark - Gestures

- (void) pinch:(UIPinchGestureRecognizer*) pinchRecognizer {
    if (pinchRecognizer.state == UIGestureRecognizerStateChanged ||
        pinchRecognizer.state == UIGestureRecognizerStateEnded) {
        self.scale *= pinchRecognizer.scale;
        pinchRecognizer.scale = 1;
    }
}

- (void) pan:(UIPanGestureRecognizer*) panRecognizer {
    if (panRecognizer.state == UIGestureRecognizerStateChanged ||
        panRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [panRecognizer translationInView:self];
        self.origin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
        [panRecognizer setTranslation:CGPointZero inView:self];
    }
}

@end
