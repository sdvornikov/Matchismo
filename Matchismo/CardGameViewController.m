//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Sergey on 2013-02-03.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong,nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipOutcomeLabel;
@property (strong,nonatomic) NSMutableArray *gameHistory; // of strings
@property (weak, nonatomic) IBOutlet UISlider *gameHistorySlider;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;

@end

@implementation CardGameViewController

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.startingCardCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animated:NO];
    return cell;
}

- (void)updateCell:(UICollectionViewCell*)cell usingCard:(Card*)card animated:(BOOL)animated { }

- (void)updateUI {

    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *path = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:path.item];
        [self updateCell:cell usingCard:card animated:YES];
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
    return nil;
}

- (int)gameMode {
    return TWO_CARDS_MATCHING_GAME; // default value
}

#pragma mark Setters & Getters

- (CardMatchingGame *)game {
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
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
/*    UIImage *cardBackImage = [self cardBackImage];
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
 */
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

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *path = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (path) {
        [self.game flipCardAtIndex:path.item];
        [self updateScoreLable];
        [self updateUI];
        self.flipCount++;
        [self displayLastFlipInfoForCards:self.game.lastFlippedCards forOutcome:self.game.lastFlipOutcome points:self.game.lastScoreChange];
    }
    

}
- (IBAction)showGameHistory:(UISlider *)sender {
    self.lastFlipOutcomeLabel.alpha = 0.5;
    self.lastFlipOutcomeLabel.attributedText = self.gameHistory[(int) sender.value];
}

@end