//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Sergey on 2013-02-10.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetDeck.h"
#import "SetCollectionViewCell.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (NSInteger)startingCardCount
{
    return 12;
}

- (Deck*)createNewDeck {
    return [[SetDeck alloc] init];
}

- (int)gameMode {
    return THREE_CARDS_MATCHING_GAME;
}

- (void)updateCell:(UICollectionViewCell*)cell usingCard:(Card*)card animated:(BOOL)animated
{
    if ([cell isKindOfClass:[SetCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCollectionViewCell*)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard*) card;
            setCardView.number = setCard.number+1;
            setCardView.symbol = setCard.symbol;
            setCardView.color = setCard.color;
            setCardView.shading = setCard.shading;
            setCardView.selected = setCard.isFaceUp;
        }
    }

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
