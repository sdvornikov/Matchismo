//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Sergey on 2013-03-03.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "CardView.h"

@interface PlayingCardView : CardView

@property (nonatomic) NSUInteger rank;
@property (nonatomic,strong) NSString *suit;
@property (nonatomic) BOOL faceUp;

- (void)flipCardAnimated;

@end
