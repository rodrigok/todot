//
//  RKArkView.m
//  RKArcView
//
//  Created by Rodrigo K on 2/24/14.
//  Copyright (c) 2014 Rodrigo Krummenauer. All rights reserved.
//

#import "RKArkView.h"

@interface RKArkView () {
    CGFloat startAngle;
    CGFloat endAngle;
    UIBezierPath* bezierPath;
}

@end

@implementation RKArkView

@synthesize strokeColor = _strokeColor;
@synthesize strokeWidth = _strokeWidth;
@synthesize radius = _radius;
@synthesize percent = _percent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        // Determine our start and stop angles for the arc (in radians)
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Determine our start and stop angles for the arc (in radians)
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
        bezierPath = [UIBezierPath bezierPath];
        _percent = 100;
        _strokeColor = [UIColor grayColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_strokeColor == nil) {
        _strokeColor = [UIColor blueColor];
    }
    
    if (_strokeWidth == 0) {
        _strokeWidth = 2;
    }

    CGFloat internalRadius = _radius;
    if (internalRadius == 0) {
        internalRadius = MIN(rect.size.width, rect.size.height) / 2.0f - (_strokeWidth / 2);
    }

    bezierPath.lineWidth = _strokeWidth;
    [bezierPath removeAllPoints];
    // Create our arc, with the correct angles
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:internalRadius
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (_percent / 100.0) + startAngle
                       clockwise:YES];
    
    
    // Set the display for the path, and stroke it

    [_strokeColor setStroke];
//    [[UIColor blueColor] setStroke];
    [bezierPath stroke];
    
    
}

# pragma mark - Setters

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

- (UIColor *)strokeColor {
    return _strokeColor;
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    _strokeWidth = strokeWidth;
    [self setNeedsDisplay];
}

- (CGFloat)strokeWidth {
    return _strokeWidth;
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self setNeedsDisplay];
}

- (CGFloat)radius {
    return _radius;
}

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    [self setNeedsDisplay];
}

- (CGFloat)percent {
    return _percent;
}

@end