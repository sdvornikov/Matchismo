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
    [self drawDiamondAtPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
                   withColor:COLOR_RED
                     shading:SHADING_OPEN
                        size:40];
}

- (void)drawDiamondAtPoint:(CGPoint)origin
                 withColor:(NSInteger)color
                   shading:(NSInteger) shading
                      size:(CGFloat) size
{
    UIBezierPath *shape = [self makePathForShape:SYMBOL_DIAMOND atPoint:origin size:size];
    [[UIColor redColor] setStroke];
    [shape stroke];
    
    //[roundedRect addClip];
    //[[UIColor whiteColor] setFill];
}

#define SYMBOL_SQUEEZE_FACTOR 2
- (UIBezierPath*)makePathForShape:(NSInteger)symbol
                          atPoint:(CGPoint)origin
                             size:(CGFloat) size
{
    UIBezierPath *shape;
    if (symbol == SYMBOL_DIAMOND) {
        shape = [[UIBezierPath alloc] init];
        [shape moveToPoint:CGPointMake(origin.x, origin.y-size/2/SYMBOL_SQUEEZE_FACTOR)];
        [shape addLineToPoint:CGPointMake(origin.x+size/2, origin.y)];
        [shape addLineToPoint:CGPointMake(origin.x, origin.y+size/2/SYMBOL_SQUEEZE_FACTOR)];
        [shape addLineToPoint:CGPointMake(origin.x-size/2, origin.y)];
        [shape closePath];
    }
    if (symbol == SYMBOL_OVAL) {
        shape = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(origin.x-size/2,
                                                                  origin.y-size/2/SYMBOL_SQUEEZE_FACTOR,
                                                                  size,
                                                                  size/SYMBOL_SQUEEZE_FACTOR)];
    }
    return shape;
}

@end
