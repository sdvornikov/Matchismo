//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Sergey on 2013-03-04.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
