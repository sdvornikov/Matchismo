//
//  SetDeck.m
//  Matchismo
//
//  Created by Sergey on 2013-02-10.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck
- (id)init {
    self = [super init];
    if (self) {
        for (NSUInteger number = 0; number < 3; number++) {
            for (NSUInteger symbol = 0; symbol < 3; symbol++) {
                for (NSUInteger shading = 0; shading < 3; shading++) {
                    for (NSUInteger color = 0; color < 3; color++) {
                        SetCard* card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}
@end
