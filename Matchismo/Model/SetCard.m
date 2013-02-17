//
//  SetCard.m
//  Matchismo
//
//  Created by Sergey on 2013-02-10.
//  Copyright (c) 2013 Sergey. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

+ (NSArray*) numberStrings {
    return @[@"one",@"two",@"three"];
}
+ (NSArray*) symbolStrings {
    return @[@"diamond",@"squiggle",@"oval"];
}
+ (NSArray*) shadingStrings {
    return @[@"solid",@"striped",@"open"];
}
+ (NSArray*) colorStrings {
    return @[@"red",@"green",@"purple"];
}

- (NSString *)contents {
    return [NSString stringWithFormat:@"%@ %@ %@ %@",[SetCard numberStrings][self.number], [SetCard colorStrings][self.color], [SetCard shadingStrings][self.shading], [SetCard symbolStrings][self.symbol]];
}

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    
    return score;
}

@end
