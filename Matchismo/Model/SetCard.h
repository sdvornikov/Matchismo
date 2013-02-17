//
//  SetCard.h
//  Matchismo
//
//  Created by Sergey on 2013-02-10.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

#define NUMBER_1 0
#define NUMBER_2 1
#define NUMBER_3 2
@property (nonatomic) NSUInteger number;
#define SYMBOL_DIAMOND 0
#define SYMBOL_SQUIGGLE 1
#define SYMBOL_OVAL 2
@property (nonatomic) NSUInteger symbol;
#define SHADING_SOLID 0
#define SHADING_STRIPED 1
#define SHADING_OPEN 2
@property (nonatomic) NSUInteger shading;
#define COLOR_RED 0
#define COLOR_GREEN 1
#define COLOR_PURPLE 2
@property (nonatomic) NSUInteger color;

@end
