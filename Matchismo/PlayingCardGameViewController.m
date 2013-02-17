//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Sergey on 2013-02-10.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (void)updateUI {
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateNormal];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        if ((cardButton.isSelected && !card.isFaceUp) || (!cardButton.isSelected && card.isFaceUp)) {
            [self flipCardButtonAnimated:cardButton];
        }
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
    }
}

- (void) flipCardButtonAnimated:(UIButton*)button {
    [UIView beginAnimations:@"flipCard" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:button cache:YES];
    [UIView setAnimationDuration:0.4];
    [UIView commitAnimations];
}

- (CardMatchingGame *)createNewGame {
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          gameMode:TWO_CARDS_MATCHING_GAME
                                                         usingDeck:[[PlayingCardDeck alloc] init]];
}

- (UIImage*)cardBackImage {
    return [UIImage imageNamed:@"cardback.png"];
}

@end
