//
//  TheSetGameViewController.m
//  Matchismo
//
//  Created by pritish jacob on 6/16/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "TheSetGameViewController.h"
#import "TheSetCardDeck.h"
#import "TheSetCard.h"

@interface TheSetGameViewController ()

@end

@implementation TheSetGameViewController

- (Deck *)createDeck
{
    return [[TheSetCardDeck alloc] init];
}


- (NSUInteger)maxNumberOfCardsAllowedToDraw
{
    return 3;
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)bindUIButtonToCard:(UIButton *)cardButton cardToBind:(Card *)card {
    if ([card isKindOfClass:[TheSetCard class]]) {
        TheSetCard *aSetCard = (TheSetCard *)card;
        NSMutableString *unstyledTitle = [[NSMutableString alloc] initWithString:aSetCard.symbol];
        NSAttributedString *attributedTitle = nil;
        NSDictionary *attributes = nil;
        for (int i=1; i<aSetCard.numberOfSymbols; i++) {
            [unstyledTitle appendString:aSetCard.symbol];
        }
        if ([aSetCard.color caseInsensitiveCompare:@"green"] == NSOrderedSame) {
            attributes = @{NSForegroundColorAttributeName: [UIColor greenColor], NSStrokeWidthAttributeName: aSetCard.shadingStroke };
        } else if ([aSetCard.color caseInsensitiveCompare:@"red"] == NSOrderedSame) {
            attributes = @{NSForegroundColorAttributeName: [UIColor redColor], NSStrokeWidthAttributeName: aSetCard.shadingStroke };
        } else if ([aSetCard.color caseInsensitiveCompare:@"purple"] == NSOrderedSame) {
            attributes = @{NSForegroundColorAttributeName: [UIColor purpleColor], NSStrokeWidthAttributeName: aSetCard.shadingStroke };
        }
        
        attributedTitle = [[NSAttributedString alloc] initWithString:unstyledTitle attributes:attributes];
        
        [cardButton setAttributedTitle:attributedTitle forState:(UIControlStateNormal)];
        [cardButton setBackgroundImage: [self backgroundImageForCard:card]
                              forState:(UIControlStateNormal)];
        cardButton.enabled = !card.isMatched;
    }
}


@end
