//
//  SetCardView.m
//  Matchismo
//
//  Created by Sergey on 2013-03-09.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#define SYMBOL_SQUEEZE_FACTOR 2

-(void)setColor:(NSUInteger)color
{
    _color = color;
    [self setNeedsDisplay];
}

-(void)setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

-(void)setShading:(NSUInteger)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

-(void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

#define CARD_ROUNDED_CORNER_RADIUS 5.0
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CARD_ROUNDED_CORNER_RADIUS];
    [roundedRect addClip];
    if (self.selected) {
        [[UIColor lightGrayColor] setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    CGFloat shapeSize = self.bounds.size.height/3;
    for (int i = 1 ; i < self.number+1 ; i++) {
        CGPoint point = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/(self.number+1)*i);
        [self drawSymbolAtPoint:point size:shapeSize];
    }
}

- (void)drawSymbolAtPoint:(CGPoint)origin
                     size:(CGFloat)size
{
    UIBezierPath *shape = [self makeSymbolPathAtPoint:origin size:size];
    [[self symbolColor] setStroke];
    [[self symbolColor] setFill];
    [shape stroke];
    [self shadeShape:shape];

}

-(UIColor*)symbolColor
{
    UIColor *color;
    if (self.color == COLOR_RED) {
        color = [UIColor redColor];
    } else if (self.color == COLOR_GREEN) {
        color = [UIColor greenColor];
    } else if (self.color == COLOR_PURPLE) {
        color = [UIColor purpleColor];
    }
    return color;
}

- (void)shadeShape:(UIBezierPath*)shape
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [shape addClip];
    if (self.shading == SHADING_SOLID) {
        CGContextFillRect(context, self.bounds);
    } else if (self.shading == SHADING_STRIPED) {
        for (CGFloat i = self.bounds.origin.x; i <= self.bounds.size.width; i+=3) {
            CGContextMoveToPoint(context, i, self.bounds.origin.y);
            CGContextAddLineToPoint(context, i, self.bounds.origin.y+self.bounds.size.height);
            CGContextStrokePath(context);
        }
    }
    
    CGContextRestoreGState(context);
}

- (UIBezierPath*)makeSymbolPathAtPoint:(CGPoint)origin
                                  size:(CGFloat) size
{
    UIBezierPath *shape;
    if (self.symbol == SYMBOL_DIAMOND) {
        shape = [[UIBezierPath alloc] init];
        [shape moveToPoint:CGPointMake(origin.x, origin.y-size/2/SYMBOL_SQUEEZE_FACTOR)];
        [shape addLineToPoint:CGPointMake(origin.x+size/2, origin.y)];
        [shape addLineToPoint:CGPointMake(origin.x, origin.y+size/2/SYMBOL_SQUEEZE_FACTOR)];
        [shape addLineToPoint:CGPointMake(origin.x-size/2, origin.y)];
        [shape closePath];
    } else if (self.symbol == SYMBOL_OVAL) {
        shape = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(origin.x-size/2,
                                                                  origin.y-size/2/SYMBOL_SQUEEZE_FACTOR,
                                                                  size,
                                                                  size/SYMBOL_SQUEEZE_FACTOR)];
    } else if (self.symbol == SYMBOL_SQUIGGLE) {
        shape = [[UIBezierPath alloc] init];
        origin = CGPointMake(origin.x, origin.y-size/10);
        [shape moveToPoint:CGPointMake(origin.x-size/2, origin.y)];
        [shape addCurveToPoint:CGPointMake(origin.x+size/2, origin.y)
                 controlPoint1:CGPointMake(origin.x-size/3, origin.y-25)
                 controlPoint2:CGPointMake(origin.x+size/3, origin.y+10)];
        [shape addQuadCurveToPoint:CGPointMake(origin.x+size/2, origin.y+size/5)
                      controlPoint:CGPointMake(origin.x+size/1.7, origin.y-size/11)];
        [shape addCurveToPoint:CGPointMake(origin.x-size/2, origin.y+size/5)
                 controlPoint1:CGPointMake(origin.x+size/3, origin.y+25)
                 controlPoint2:CGPointMake(origin.x-size/3, origin.y-10)];
        [shape addQuadCurveToPoint:CGPointMake(origin.x-size/2, origin.y)
                      controlPoint:CGPointMake(origin.x-size/1.9, origin.y+size/6)];
        [shape closePath];
        
    }
    return shape;
}

@end
