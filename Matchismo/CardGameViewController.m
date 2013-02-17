//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Sergey on 2013-02-03.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipOutcomeLabel;
@property (strong,nonatomic) NSMutableArray *gameHistory; // of strings
@property (weak, nonatomic) IBOutlet UISlider *gameHistorySlider;

@end

@implementation CardGameViewController

- (void)updateUI {
    // must be overriden by subclasses 
}

- (void) updateScoreLable {
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)displayLastFlipInfoForCards:(NSArray*)cards forOutcome:(int) outcome points:(int) points {
    if (outcome == FLIP) {
        self.lastFlipOutcomeLabel.text = [NSString stringWithFormat:@"Flipped up %@. Costs %d point",[[cards lastObject] description], abs(points)];
    } else if (outcome == MATCH) {
        self.lastFlipOutcomeLabel.text = [NSString stringWithFormat:@"Matched %@ for %d points",[cards componentsJoinedByString:@" & "], points];
    } else if (outcome == MISMATCH) {
        self.lastFlipOutcomeLabel.text = [NSString stringWithFormat:@"%@ don’t match! %d points!",[cards componentsJoinedByString:@" & "], points];
    }
    
    self.lastFlipOutcomeLabel.alpha = 1;
    [self.gameHistory addObject:self.lastFlipOutcomeLabel.text];
    if ([self.gameHistory count] == 0) {
        self.gameHistorySlider.enabled = NO;
    } else {
        self.gameHistorySlider.enabled = YES;
        //  -0.5 for setting minimum range of 0..0.5 when there's only one history record
        // it makes the slider set always at the most right position.
        self.gameHistorySlider.maximumValue = [self.gameHistory count]-0.5;
        self.gameHistorySlider.value = [self.gameHistory count]-0.5;
    }
    
}

- (CardMatchingGame*)createNewGame {
    return nil;
}

#pragma mark Setters & Getters

- (CardMatchingGame *)game {
    if(!_game) _game = [self createNewGame];
    return _game;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    UIImage *blankImage = [[UIImage alloc] init];
    for (UIButton *button in cardButtons) {
        [button setImage:cardBackImage forState:UIControlStateNormal];
        [button setImage:blankImage forState:UIControlStateSelected];
        [button setImage:blankImage forState:UIControlStateDisabled|UIControlStateSelected];
        [button setImage:blankImage forState:UIControlStateHighlighted|UIControlStateSelected];
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    [self updateUI];
    
}

- (NSMutableArray *)gameHistory {
    if (!_gameHistory) {
        _gameHistory = [[NSMutableArray alloc] init];
    }
    return _gameHistory;
}

#pragma mark IBActions

- (IBAction)dialNewCards:(UIButton *)sender {
    self.game = nil;
    self.flipCount = 0;
    self.lastFlipOutcomeLabel.text = @"";
    self.gameHistory = nil;
    self.gameHistorySlider.enabled = NO;
    [self updateScoreLable];
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self updateScoreLable];
    [self updateUI];
    self.flipCount++;
    [self displayLastFlipInfoForCards:self.game.lastFlippedCards forOutcome:self.game.lastFlipOutcome points:self.game.lastScoreChange];
}
- (IBAction)showGameHistory:(UISlider *)sender {
    self.lastFlipOutcomeLabel.alpha = 0.5;
    self.lastFlipOutcomeLabel.text = self.gameHistory[(int) sender.value];
}

@end