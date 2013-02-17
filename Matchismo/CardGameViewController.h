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

@property (strong,nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

// Have to override this. Must return valid CardMatchingGame object. Default is nil.
//- (CardMatchingGame*)createNewGame;

// Override this to implement how game state must be shown.
//- (void)updateUI;
@end
