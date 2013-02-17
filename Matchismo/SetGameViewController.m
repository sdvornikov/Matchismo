//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Sergey on 2013-02-10.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetDeck.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (CardMatchingGame *)createNewGame {
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                              gameMode:THREE_CARDS_MATCHING_GAME
                                             usingDeck:[[SetDeck alloc] init]];
}

@end
