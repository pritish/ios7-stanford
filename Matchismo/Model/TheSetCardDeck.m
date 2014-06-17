//
//  TheSetCardDeck.m
//  Matchismo
//
//  Created by pritish jacob on 6/16/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "TheSetCardDeck.h"
#import "TheSetCard.h"
@implementation TheSetCardDeck

- (instancetype)init {
    self = [super init];
    
    if (self) {
        for (NSString *symbol in [TheSetCard validSymbols]) {
            for (NSUInteger numberOfSymbols=1; numberOfSymbols <= [TheSetCard maxNumberOfSymbols]; numberOfSymbols++) {
                for (NSString *color in [TheSetCard validColors]){
                    for (NSNumber *shadingStroke in [TheSetCard validShadingStrokes]) {
                        TheSetCard *card = [[TheSetCard alloc] init];
                        card.numberOfSymbols = numberOfSymbols;
                        card.symbol = symbol;
                        card.color = color;
                        card.shadingStroke = shadingStroke;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}
@end
