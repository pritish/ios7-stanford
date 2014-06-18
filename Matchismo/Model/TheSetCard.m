//
//  TheSetCard.m
//  Matchismo
//
//  Created by pritish jacob on 6/16/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "TheSetCard.h"

@implementation TheSetCard

- (NSString *)contents {
    return nil;
}

@synthesize symbol = _symbol;
@synthesize shading = _shading;
@synthesize color = _color;
@synthesize numberOfSymbols = _numberOfSymbols;

+ (NSUInteger)maxNumberOfSymbols {
    return [[self rankStrings] count];
}

+ (NSArray *)rankStrings {
    return @[@"1", @"2", @"3"];
}

+ (NSArray *)validSymbols {
    // allows playing Set with any three distinct shapes @"▲", @"●", @"■"
    return @[@"triangle", @"circle", @"square"];
}

+ (NSArray *)validShading {
    return @[@"striped", @"solid", @"open"];
}

+ (NSArray *)validColors {
    return @[@"red", @"green", @"purple"];
}

- (void)setShadingStroke:(NSString *)shading {
    if ([[TheSetCard validShading] containsObject:shading]) {
        _shading = shading;
    }
}

- (void)setColor:(NSString *)color {
    if ([[TheSetCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (void)setSymbol:(NSString *)symbol {
    if ([[TheSetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (void)setNumberOfSymbols:(NSUInteger)numberOfSymbols {
    if (numberOfSymbols <= [TheSetCard maxNumberOfSymbols]) {
        _numberOfSymbols = numberOfSymbols;
    }
}

- (NSString *)symbol {
    return _symbol ? _symbol : @"?";
}

- (int)match:(NSArray *)otherCards {
    int score = 0;
    BOOL matchOnNumberOfSymbols = false;
    BOOL matchOnSymbols = false;
    BOOL matchOnShadings = false;
    BOOL matchOnColors = false;
    
    if ([otherCards count] == 2) {
        TheSetCard *firstOtherCard = otherCards[0];
        TheSetCard *secondOtherCard = otherCards[1];
        if ([firstOtherCard isKindOfClass:[TheSetCard class]] &&
            [secondOtherCard isKindOfClass:[TheSetCard class]]) {
            
            if (((firstOtherCard.numberOfSymbols == self.numberOfSymbols) && (secondOtherCard.numberOfSymbols == self.numberOfSymbols)) ||
                ((firstOtherCard.numberOfSymbols != self.numberOfSymbols) && (secondOtherCard.numberOfSymbols != self.numberOfSymbols) && (firstOtherCard.numberOfSymbols != secondOtherCard.numberOfSymbols))) {
                matchOnNumberOfSymbols = true;
            }
            
            if (((firstOtherCard.symbol == self.symbol) && (secondOtherCard.symbol == self.symbol)) ||
                ((firstOtherCard.symbol != self.symbol) && (secondOtherCard.symbol != self.symbol) && (firstOtherCard.symbol != secondOtherCard.symbol))) {
                matchOnSymbols = true;
            }
            
            if (((firstOtherCard.shading == self.shading) && (secondOtherCard.shading == self.shading)) ||
                ((firstOtherCard.shading != self.shading) && (secondOtherCard.shading != self.shading) && (firstOtherCard.shading != secondOtherCard.shading))) {
                matchOnShadings = true;
            }
            
            if (((firstOtherCard.color == self.color) && (secondOtherCard.color == self.color)) ||
                ((firstOtherCard.color != self.color) && (secondOtherCard.color != self.color) && (firstOtherCard.color != secondOtherCard.color))) {
                matchOnColors = true;
            }
            
            if (matchOnNumberOfSymbols && matchOnSymbols && matchOnShadings && matchOnColors)
                score = 12;
        }
    
    }
    
    return score;
}

@end
