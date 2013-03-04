//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Sergey on 2013-02-03.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

// Override to return specific instance of Deck subclass
// Default: nil
- (Deck*)createNewDeck;

// Override to set gamemode
// Default: TWO_CARDS_MATCHING_GAME
- (int)gameMode;

// Override to set UIButton state for card faceUp status
// Default: switches buttons selected state
- (void)updateCardButton:(UIButton*)cardButton forFaceUpStatus:(BOOL) isFaceUp;

// Override to set UIButton state for card unplayable status
// Default: switches button's enabled state and changes alpha
- (void)updateCardButton:(UIButton*)cardButton forUnplayableStatus:(BOOL) isUnplayable;

// Override to convert Card's contents to NSAttributedString for displayind in UI
// Default: contents of a card
- (NSAttributedString*) labelOfCard:(Card*) card;

//
//
@property (nonatomic) NSInteger startingCardCount;

// Override to interpret card for a viewCell
- (void)updateCell:(UICollectionViewCell*)cell usingCard:(Card*)card animated:(BOOL)animated;

@end
