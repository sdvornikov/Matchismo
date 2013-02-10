//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Sergey on 2013-02-03.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong,nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipOutcomeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSwitch;
@property (nonatomic) BOOL gameInProgress;
@property (nonatomic) int gameMode;

@end

@implementation CardGameViewController

- (void)updateUI {
    
    
    
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        if (!card.isFaceUp) {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
            cardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    
    if (self.game.lastFlipOutcome == FLIP) {
        self.lastFlipOutcomeLabel.text = [NSString stringWithFormat:@"Flipped up %@. Costs %d point",[[self.game.lastFlippedCards lastObject] description], abs(self.game.lastScoreChange)];
    } else if (self.game.lastFlipOutcome == MATCH) {
        self.lastFlipOutcomeLabel.text = [NSString stringWithFormat:@"Matched %@ for %d points",[self.game.lastFlippedCards componentsJoinedByString:@" & "], self.game.lastScoreChange];
    } else if (self.game.lastFlipOutcome == MISMATCH) {
        self.lastFlipOutcomeLabel.text = [NSString stringWithFormat:@"%@ don’t match! %d points!",[self.game.lastFlippedCards componentsJoinedByString:@" & "], self.game.lastScoreChange];
    }
}

#pragma mark Setters & Getters

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void)setGameInProgress:(BOOL)gameInProgress {
    _gameInProgress = gameInProgress;
    self.gameModeSwitch.enabled = !self.gameInProgress;
}

- (CardMatchingGame *)game {
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          gameMode:self.gameMode
                                                         usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
    
}

#pragma mark IBActions

- (IBAction)gameModeChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.gameMode = TWO_CARDS_MATCHING_GAME;
    } else if (sender.selectedSegmentIndex == 1) {
        self.gameMode = THREE_CARDS_MATCHING_GAME;
    }
    self.game.gameMode = self.gameMode;
}

- (IBAction)dialNewCards:(UIButton *)sender {
    self.gameInProgress = NO;
    self.game = nil;
    self.flipCount = 0;
    self.lastFlipOutcomeLabel.text = @"";
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender {
    if (!self.gameInProgress) self.gameInProgress = YES;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self updateUI];
    self.flipCount++;
}

@end