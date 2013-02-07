//
//  PlayingCard.m
//  Matchismo
//
//  Created by Sergey on 2013-02-03.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "PlayingCard.h"
@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    NSMutableArray *cardToMatch = [otherCards mutableCopy];
    [cardToMatch addObject:self];
    int score = 0;
    
    for (int i = 0; i < [cardToMatch count]; i++) {
        PlayingCard *card = [cardToMatch objectAtIndex:i];
        for (int j = i + 1; j < [cardToMatch count]; j++) {
            PlayingCard *otherCard = [cardToMatch objectAtIndex:j];
            if ([otherCard.suit isEqualToString:card.suit]) {
                score += 2;
            } else if (otherCard.rank == card.rank) {
                score += 8;
            }
        }
    }
    
    if (score > 0) score /= [otherCards count];
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}
@synthesize suit = _suit; // because we provide setter AND getter
+ (NSArray *)validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}
- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    } }
- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}
+ (NSUInteger)maxRank { return [self rankStrings].count-1; }
- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    } }
@end