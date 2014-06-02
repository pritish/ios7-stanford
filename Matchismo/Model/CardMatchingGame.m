//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by pritish jacob on 5/14/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)playingCardCount usingDeck:(Deck *)deck numberOfCardsToDraw:(NSUInteger)matchThisNumberOfCards {
    self = [super init];
    
    if (self) {
        self.maxCardsToDraw = matchThisNumberOfCards;
        for (int i=0; i<playingCardCount; i++) {
            Card *aCard = [deck drawRandomCard];
            if (aCard) {
                [self.cards addObject:aCard];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isMatched) {
        if (card.isChosen){
            // ischosen + !ismatch -> unchoose card
            card.chosen = NO;
        } else {
            
            // match: choose card +
            NSMutableArray *otherChosenCards = [[NSMutableArray alloc] init];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [otherChosenCards addObject:otherCard];
                }
            }
            
            if ([otherChosenCards count]+1 >= self.maxCardsToDraw) {
                // match() only after game size - number of cards chosen - is reached
                int matchScore = [card match:otherChosenCards];
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    for (Card *otherCard in otherChosenCards) {
                        otherCard.matched = YES;
                    }
                    card.matched = YES;
                } else {
                    self.score -= MISMATCH_PENALTY;
                    if ([otherChosenCards count]+1 >= self.maxCardsToDraw) {
                        for (Card *otherCard in otherChosenCards) {
                            otherCard.chosen = NO;
                        }
                    }
                }
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

@end
