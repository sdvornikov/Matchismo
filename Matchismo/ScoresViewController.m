//
//  ScoresViewController.m
//  Matchismo
//
//  Created by Sergey on 2013-03-03.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "ScoresViewController.h"
#import "SetCardView.h"


@interface ScoresViewController ()
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;

@end

@implementation ScoresViewController

-(void)viewDidLoad
{
    self.setCardView.symbol = SYMBOL_SQUIGGLE;
    self.setCardView.shading = SHADING_OPEN;
    self.setCardView.color = COLOR_GREEN;
    self.setCardView.number = NUMBER_2;
}

@end
