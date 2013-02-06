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
@property (readwrite,nonatomic) int lastFlipOutcome;
@property (readwrite,nonatomic) int lastScoreChange;
@property (readwrite,nonatomic) NSArray *lastFlippedCards;
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
    NSMutableArray *cardsInvolved = [[NSMutableArray alloc] init];
    
    self.lastScoreChange = 0;
    self.lastFlipOutcome = 0;
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            self.lastFlipOutcome = FLIP;
            [cardsInvolved addObject:card];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [otherCard match:@[card]];
                    [cardsInvolved addObject:otherCard];
                    if (matchScore) {
                        card.unplayeble = YES;
                        otherCard.unplayeble = YES;
                        self.lastScoreChange += matchScore * MATCH_BONUS;
                        self.lastFlipOutcome = MATCH;
                    } else {
                        otherCard.faceUp = NO;
                        self.lastScoreChange -= MISMATCH_PENALTY;
                        self.lastFlipOutcome = MISMATCH;
                    }
                    break;
                }
            }
            self.lastScoreChange -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
    self.score += self.lastScoreChange;
    self.lastFlippedCards = [cardsInvolved copy];
}


@end
