//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by pritish jacob on 5/14/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)playingCardCount usingDeck:(Deck *)deck numberOfCardsToDraw:(NSUInteger)matchThisNumberOfCards;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readwrite) NSUInteger maxCardsToDraw;
@property (nonatomic, readonly) NSMutableArray *gameHistory;

@end
