//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Sergey on 2013-02-10.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardCollectionViewCell.h"
#import "PlayingCard.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (void)updateCardButton:(UIButton*)cardButton forFaceUpStatus:(BOOL) isFaceUp {
    if ((cardButton.isSelected && !isFaceUp) || (!cardButton.isSelected && isFaceUp)) {
        [self flipCardButtonAnimated:cardButton];
    }
    cardButton.selected = isFaceUp;
}

- (void) flipCardButtonAnimated:(UIButton*)button {
    [UIView beginAnimations:@"flipCard" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:button cache:YES];
    [UIView setAnimationDuration:0.4];
    [UIView commitAnimations];
}

- (Deck*)createNewDeck {
    return [[PlayingCardDeck alloc] init];
}

- (int)gameMode {
    return TWO_CARDS_MATCHING_GAME;
}

- (NSInteger)startingCardCount
{
    return 20;
}

- (void)updateCell:(UICollectionViewCell*)cell usingCard:(Card*)card animated:(BOOL)animated
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell*)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard*) card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            if (playingCardView.faceUp != playingCard.isFaceUp) {
                if (animated) {
                    [playingCardView flipCardAnimated];
                }
                playingCardView.faceUp = playingCard.isFaceUp;
            }
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

@end
