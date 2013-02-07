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

- (int)gameMode {
    if (_gameMode != TWO_CARDS_MATCHING_GAME && _gameMode != THREE_CARDS_MATCHING_GAME) {
        _gameMode = TWO_CARDS_MATCHING_GAME;
    }
    return _gameMode;
}

- (id)initWithCardCount:(NSInteger)count gameMode:(int) gameMode usingDeck:(Deck *)desk {
    
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
        self.gameMode = gameMode;
    }
    return self;
}

- (Card *)cardAtIndex:(NSInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define MATCH_BONUS 2
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
            if ((self.gameMode == TWO_CARDS_MATCHING_GAME && [[self flippedUpCards] count] == 1) ||
                (self.gameMode == THREE_CARDS_MATCHING_GAME && [[self flippedUpCards] count] == 2)) {
                int matchScore = [card match:[self flippedUpCards]];
                [cardsInvolved addObjectsFromArray:[self flippedUpCards]];
                if (matchScore) {
                    card.unplayeble = YES;
                    [self setUnplayeble:YES faceUp:YES ForCards:[self flippedUpCards]];
                    self.lastScoreChange += matchScore * MATCH_BONUS;
                    self.lastFlipOutcome = MATCH;
                } else {
                    [self setUnplayeble:NO faceUp:NO ForCards:[self flippedUpCards]];
                    self.lastScoreChange -= MISMATCH_PENALTY;
                    self.lastFlipOutcome = MISMATCH;
                }
            }
            self.lastScoreChange -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
    self.score += self.lastScoreChange;
    self.lastFlippedCards = [cardsInvolved copy];
}

- (NSArray *)flippedUpCards {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (Card *card in self.cards) {
        if (card.isFaceUp && !card.isUnplayable) {
            [result addObject:card];
        }
    }
        return [result copy];
}

- (void)setUnplayeble:(BOOL) unplayeble faceUp:(BOOL) faceUp ForCards:(NSArray *)cards {
    for (Card *card in cards) {
        card.unplayeble = unplayeble;
        card.faceUp = faceUp;
    }
}

@end
