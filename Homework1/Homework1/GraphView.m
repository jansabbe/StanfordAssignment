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
    self.contentMode = UIViewContentModeRedraw;
    self.contentScaleFactor = 1;
    self.origin = [self middlePoint];
    self.scale = 1;
}

#pragma mark - Drawing rect

- (void)drawRect:(CGRect)rect {
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
    [self drawGraphInRect:rect];
}


#pragma mark - Utility methods

- (void) drawGraphInRect:(CGRect) rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(context);
    
    [[UIColor blueColor] setStroke];
	CGContextBeginPath(context);
    
    CGPoint startPoint = [self getPlotPointInViewCoordinatesWithX:rect.origin.x];
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    
    for (double xInViewCoordinates = rect.origin.x; xInViewCoordinates <= rect.size.width; xInViewCoordinates++) {
        CGPoint point = [self getPlotPointInViewCoordinatesWithX:xInViewCoordinates];
        CGContextAddLineToPoint(context, point.x, point.y);
    }
    
	CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (CGFloat) convertXToAxisCoordinates: (CGFloat) viewCoordinatesX {
    return (viewCoordinatesX - self.origin.x) / self.scale;
}

- (CGPoint) convertToViewCoordinates: (CGPoint) point {
    return CGPointMake(self.origin.x + (point.x * self.scale), self.origin.y + (point.y * -self.scale));
}

- (CGPoint) getPlotPointInViewCoordinatesWithX:(CGFloat) xInViewCoordinates {
    double xInAxis = [self convertXToAxisCoordinates:xInViewCoordinates];
    double yInAxis = [self.delegate giveYForX:xInAxis inView:self];
    return [self convertToViewCoordinates:CGPointMake(xInAxis, yInAxis)];
}

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

- (void) tap:(UITapGestureRecognizer*) tapRecognizer {
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        self.origin = [tapRecognizer locationInView:self];
    }
}

@end
