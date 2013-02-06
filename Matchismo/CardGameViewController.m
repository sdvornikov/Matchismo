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

@end

@implementation CardGameViewController

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
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
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
    
}

#pragma mark IBActions

- (IBAction)gameModeChanged:(UISegmentedControl *)sender {
    // do something to change game mode
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