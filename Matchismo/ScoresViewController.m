//
//  ScoresViewController.m
//  Matchismo
//
//  Created by Sergey on 2013-03-03.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "ScoresViewController.h"
#import "PlayingCardView.h"

@interface ScoresViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end

@implementation ScoresViewController

- (void)setPlayingCardView:(PlayingCardView *)playingCardView
{
    _playingCardView = playingCardView;
    self.playingCardView.suit = @"♥";
    self.playingCardView.rank = 13;
}

@end
