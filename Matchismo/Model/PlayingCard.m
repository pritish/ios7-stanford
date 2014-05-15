//
//  PlayingCard.m
//  Matchismo
//
//  Created by pritish jacob on 5/11/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard 

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSUInteger)maxRank {
    return [[self rankStrings] count] - 1;
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSArray *)validSuits {
    return @[@"♠", @"♣", @"♥", @"♦"];
}

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    if ([otherCards count] == 1) {
        id otherCard = [otherCards firstObject];
        if ([otherCard isKindOfClass:[PlayingCard class]]) {
            if (((PlayingCard *)otherCard).rank == self.rank) {
                score = 4;
            } else if (((PlayingCard *)otherCard).suit == self.suit) {
                score = 1;
            }
        }
    }
    return score;
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

@end
