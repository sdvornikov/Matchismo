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
@property (strong,nonatomic) NSMutableArray *gameHistory; // of strings
@property (weak, nonatomic) IBOutlet UISlider *gameHistorySlider;

@end

@implementation CardGameViewController

- (void)updateUI {
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateNormal];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        if (cardButton.isSelected && !card.isFaceUp) {
            [self flipCardButtonAnimated:cardButton];
        }
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void) flipCardButtonAnimated:(UIButton*)button {
    [UIView beginAnimations:@"flipCard" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:button cache:YES];
    [UIView setAnimationDuration:0.4];
    [UIView commitAnimations];
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
    self.gameHistory = nil;
    self.gameHistorySlider.enabled = NO;
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender {
    if (!self.gameInProgress) self.gameInProgress = YES;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self updateUI];
    self.flipCount++;
    [self displayLastFlipInfoForCards:self.game.lastFlippedCards forOutcome:self.game.lastFlipOutcome points:self.game.lastScoreChange];
    [self flipCardButtonAnimated:sender];
}
- (IBAction)showGameHistory:(UISlider *)sender {
    self.lastFlipOutcomeLabel.alpha = 0.5;
    self.lastFlipOutcomeLabel.text = self.gameHistory[(int) sender.value];
}

@end