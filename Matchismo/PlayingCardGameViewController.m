//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by pritish jacob on 6/16/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)maxNumberOfCardsAllowedToDraw
{
    return 2;
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)bindUIButtonToCard:(UIButton *)cardButton cardToBind:(Card *)card {
    [cardButton setTitle:[self titleForCard:card] forState:(UIControlStateNormal)];
    [cardButton setBackgroundImage: [self backgroundImageForCard:card]
                          forState:(UIControlStateNormal)];
    cardButton.enabled = !card.isMatched;
}

@end
