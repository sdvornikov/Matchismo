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
@property (strong,nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipOutcomeLabel;
@property (strong,nonatomic) NSMutableArray *gameHistory; // of strings
@property (weak, nonatomic) IBOutlet UISlider *gameHistorySlider;

@end

@implementation CardGameViewController

- (void)updateUI {
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setAttributedTitle:[self labelOfCard:card] forState:UIControlStateNormal];
        [cardButton setAttributedTitle:[self labelOfCard:card] forState:UIControlStateSelected];
        [self updateCardButton:cardButton forFaceUpStatus:card.isFaceUp];
        [self updateCardButton:cardButton forUnplayableStatus:card.isUnplayable];
    }
}

- (void)updateCardButton:(UIButton*)cardButton forFaceUpStatus:(BOOL) isFaceUp {
    cardButton.selected = isFaceUp;
}

- (void)updateCardButton:(UIButton*)cardButton forUnplayableStatus:(BOOL) isUnplayable {
    cardButton.enabled = !isUnplayable;
    cardButton.alpha = (isUnplayable ? 0.3 : 1.0);
}

- (NSAttributedString*) labelOfCard:(Card*) card {
    NSString* string = [NSString stringWithString:card.contents];
    NSMutableAttributedString *resultAtrString = [[NSMutableAttributedString alloc] initWithString:string];
    
    return [resultAtrString copy];
}

- (void) updateScoreLable {
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (NSAttributedString*) constructLastFlipInfoAttributedStringWithBegining:(NSString*) beg
                                                                    cards:(NSArray*) cards
                                                                   middle:(NSString*)mid
                                                                   points:(int) points
                                                                   ending:(NSString*) end {
    NSMutableAttributedString *result;
    result = [[NSMutableAttributedString alloc] initWithString:beg];
    for (Card *card in cards) {
        [result appendAttributedString:[self labelOfCard:card]];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"&"]];
    }
    [result deleteCharactersInRange:NSMakeRange([result length] - 1, 1)];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:mid]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:[@(points) stringValue]]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:end]];
    return [result copy];
}

- (void)displayLastFlipInfoForCards:(NSArray*)cards forOutcome:(int) outcome points:(int) points {
    if (outcome == FLIP) {
        self.lastFlipOutcomeLabel.attributedText = [self constructLastFlipInfoAttributedStringWithBegining:@"Flipped up "
                                                                                                     cards:cards
                                                                                                    middle:@". Costs "
                                                                                                    points:abs(points)
                                                                                                    ending:@" point"];
    } else if (outcome == MATCH) {
        self.lastFlipOutcomeLabel.attributedText = [self constructLastFlipInfoAttributedStringWithBegining:@"Matched "
                                                                                                     cards:cards
                                                                                                    middle:@" for "
                                                                                                    points:points
                                                                                                    ending:@" points"];
    } else if (outcome == MISMATCH) {
        self.lastFlipOutcomeLabel.attributedText = [self constructLastFlipInfoAttributedStringWithBegining:@""
                                                                                                     cards:cards
                                                                                                    middle:@" don’t match! "
                                                                                                    points:points
                                                                                                    ending:@" points!"];
    }
    
    self.lastFlipOutcomeLabel.alpha = 1;
    [self.gameHistory addObject:self.lastFlipOutcomeLabel.attributedText];
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

- (Deck*)createNewDeck {
    return [[Deck alloc] init];
}

- (int)gameMode {
    return TWO_CARDS_MATCHING_GAME; // default value
}

#pragma mark Setters & Getters

- (CardMatchingGame *)game {
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          gameMode:[self gameMode]
                                                         usingDeck:[self createNewDeck]];
    return _game;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    UIImage *cardBackImage = [self cardBackImage];
    if (cardBackImage) {
        UIImage *blankImage = [[UIImage alloc] init];
        for (UIButton *button in cardButtons) {
            [button setImage:cardBackImage forState:UIControlStateNormal];
            [button setImage:blankImage forState:UIControlStateSelected];
            [button setImage:blankImage forState:UIControlStateDisabled|UIControlStateSelected];
            [button setImage:blankImage forState:UIControlStateHighlighted|UIControlStateSelected];
            button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        }
    }
    [self updateUI];
}

- (UIImage*)cardBackImage {
    return nil;
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
    self.lastFlipOutcomeLabel.attributedText = self.gameHistory[(int) sender.value];
}

@end