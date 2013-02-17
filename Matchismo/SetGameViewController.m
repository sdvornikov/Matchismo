//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Sergey on 2013-02-10.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetDeck.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (CardMatchingGame *)createNewGame {
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                              gameMode:THREE_CARDS_MATCHING_GAME
                                             usingDeck:[[SetDeck alloc] init]];
}

- (NSAttributedString*) labelOfCard:(Card*) card {
    NSMutableAttributedString *resultAtrString;
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard*)card;
        NSArray *symbols = @[@"▲",@"■",@"●"];
        NSArray *shadings = @[@(1),@(0.3),@(0)];
        NSArray *colors = @[[UIColor redColor],[UIColor greenColor],[UIColor purpleColor]];
        
        NSString *string = [NSString stringWithString:symbols[setCard.symbol]];
        for (int i = 0; i < setCard.number; i++) {
            string = [string stringByAppendingString:symbols[setCard.symbol]];
        }
        
        CGFloat shading = [shadings[setCard.shading] floatValue];
        
        resultAtrString = [[NSMutableAttributedString alloc] initWithString:string];
        NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:16],
                                      NSForegroundColorAttributeName : [colors[setCard.color] colorWithAlphaComponent:shading],
                                      NSStrokeColorAttributeName : colors[setCard.color],
                                      NSStrokeWidthAttributeName : @-3};
        [resultAtrString addAttributes:attributes range:NSMakeRange(0, [string length])];
    }
    return resultAtrString;
}

@end
