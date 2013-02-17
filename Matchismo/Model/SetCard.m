//
//  SetCard.m
//  Matchismo
//
//  Created by Sergey on 2013-02-10.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

+ (NSArray*) numberStrings {
    return @[@"one",@"two",@"three"];
}
+ (NSArray*) symbolStrings {
    return @[@"diamond",@"squiggle",@"oval"];
}
+ (NSArray*) shadingStrings {
    return @[@"solid",@"striped",@"open"];
}
+ (NSArray*) colorStrings {
    return @[@"red",@"green",@"purple"];
}

- (NSString *)contents {
    return [NSString stringWithFormat:@"%@ %@ %@ %@",[SetCard numberStrings][self.number], [SetCard colorStrings][self.color], [SetCard shadingStrings][self.shading], [SetCard symbolStrings][self.symbol]];
}

- (int)match:(NSArray *)otherCards {
    NSMutableArray *cardToMatch = [otherCards mutableCopy];
    [cardToMatch addObject:self];
    BOOL setFound = YES;
    
    for (int i = 0; i < [cardToMatch count]; i++) {
        SetCard *card = [cardToMatch objectAtIndex:i];
        for (int j = i + 1; j < [cardToMatch count]; j++) {
            SetCard *otherCard = [cardToMatch objectAtIndex:j];
            if (card.number == otherCard.number ||
                card.symbol == otherCard.symbol ||
                card.shading == otherCard.shading ||
                card.color == otherCard.color) {
                setFound = NO;
                break;
            }
        }
    }
    
    return setFound ? 15 : 0;
}

@end
