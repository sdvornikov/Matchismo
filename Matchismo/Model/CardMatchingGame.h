//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Sergey on 2013-02-05.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSInteger)count
              usingDeck:(Deck *)desk;
- (void)flipCardAtIndex:(NSInteger)index;
- (Card *)cardAtIndex:(NSInteger)index;

@property (readonly,nonatomic) int score;

@end
