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
               gameMode:(int) gameMode
              usingDeck:(Deck *)desk;
- (void)flipCardAtIndex:(NSInteger)index;
- (Card *)cardAtIndex:(NSInteger)index;

#define TWO_CARDS_MATCHING_GAME 2
#define THREE_CARDS_MATCHING_GAME 3
@property (nonatomic) int gameMode;

@property (readonly,nonatomic) int score;
#define FLIP        1
#define MATCH       2
#define MISMATCH    3
@property (readonly,nonatomic) int lastFlipOutcome;
@property (readonly,nonatomic) int lastScoreChange;
@property (readonly,nonatomic) NSArray *lastFlippedCards; // of Cards

@end
