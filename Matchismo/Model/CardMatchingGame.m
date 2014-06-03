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
@property (nonatomic, strong) NSMutableArray *gameHistory;
@end

@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)gameHistory {
    if (!_gameHistory) _gameHistory = [[NSMutableArray alloc] init];
    return _gameHistory;
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
            // record in gameHistory the action and cost; unchosen costs 0
            [self.gameHistory addObject:[NSString stringWithFormat:@"%@,%d",@"Unchosen", 0 ]];
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
                    NSInteger calculatedScore = matchScore * MATCH_BONUS;
                    self.score += calculatedScore;
                    for (Card *otherCard in otherChosenCards) {
                        otherCard.matched = YES;
                    }
                    card.matched = YES;
                    // record in gameHistory the action and cost; match gives calculatedScore
                    [self.gameHistory addObject:[NSString stringWithFormat:@"%@,%d",@"Match", calculatedScore ]];
                } else {
                    self.score -= MISMATCH_PENALTY;
                    if ([otherChosenCards count]+1 >= self.maxCardsToDraw) {
                        for (Card *otherCard in otherChosenCards) {
                            otherCard.chosen = NO;
                        }
                        // record in gameHistory the action and cost; mismatch costs MISMATCH_PENALTY
                        [self.gameHistory addObject:[NSString stringWithFormat:@"%@,%d",@"Mismatch", MISMATCH_PENALTY ]];
                    }
                }
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
            // record in gameHistory the action and cost; chosen costs COST_TO_CHOOSE
            [self.gameHistory addObject:[NSString stringWithFormat:@"%@,%d",@"Chosen", COST_TO_CHOOSE ]];
        }
    }
}

@end
