//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Sergey on 2013-02-05.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Card.h"

@interface CardMatchingGame ()
@property (strong, nonatomic) NSMutableArray *cards; // of Cards
@property (readwrite, nonatomic) int score;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSInteger)count usingDeck:(Deck *)desk {
    
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card* card = desk.drawRandomCard;
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSInteger)index {
    Card *card = [self cardAtIndex:index];
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [otherCard match:@[card]];
                    if (matchScore) {
                        card.unplayeble = YES;
                        otherCard.unplayeble = YES;
                        self.score += matchScore * MATCH_BONUS;
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

@end
