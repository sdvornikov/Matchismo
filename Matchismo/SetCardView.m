//
//  SetCardView.m
//  Matchismo
//
//  Created by Sergey on 2013-03-09.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawSymbol:SYMBOL_DIAMOND atPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
                   withColor:[self symbolColor]
                     shading:SHADING_OPEN
                        size:40];
}

- (void)drawSymbol:(NSInteger)symbol
           atPoint:(CGPoint)origin
                 withColor:(UIColor*)color
                   shading:(NSInteger) shading
                      size:(CGFloat) size
{
    UIBezierPath *shape = [self makeSymbolPathAtPoint:origin size:size];
    [color setStroke];
    [color setFill];
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

#define SYMBOL_SQUEEZE_FACTOR 2
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
    }
    if (self.symbol == SYMBOL_OVAL) {
        shape = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(origin.x-size/2,
                                                                  origin.y-size/2/SYMBOL_SQUEEZE_FACTOR,
                                                                  size,
                                                                  size/SYMBOL_SQUEEZE_FACTOR)];
    }
    return shape;
}

@end
