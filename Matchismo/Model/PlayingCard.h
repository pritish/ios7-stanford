//
//  PlayingCard.h
//  Matchismo
//
//  Created by pritish jacob on 5/11/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
