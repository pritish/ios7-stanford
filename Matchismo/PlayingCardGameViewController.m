//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by pritish jacob on 6/16/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "GameHistoryViewController.h"

@interface PlayingCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultDescription;

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

- (void)updateStatusInfo {
    id lastEventObj = [self.game.gameHistory lastObject];
    if ([lastEventObj isKindOfClass:[NSString class]]) {
        //@[@"unchosen", @"chosen", @"match", @"mismatch"]
        NSString *lastEvent = (NSString *)lastEventObj;
        NSArray *lastEventParsed = [lastEvent componentsSeparatedByString:@","];
        unsigned long resultType = [[CardMatchingGame GameEventTypes] indexOfObject:[(NSString *)[lastEventParsed objectAtIndex:0] lowercaseString]];
        int resultPoints = [[lastEventParsed objectAtIndex:1] intValue];
        NSMutableString *description = [[NSMutableString alloc] init];
        switch (resultType) {
            case 0:
                // unchosen case
                for (NSString *aChosenCard in self.cardsChosen) {
                    if ([aChosenCard isKindOfClass:[NSString class]]) {
                        [description appendString:aChosenCard];
                    }
                }
                [description appendString:@" unchosen"];
                self.cardsChosen = nil;
                break;
                
            case 1:
                // chosen case
                for (NSString *aChosenCard in self.cardsChosen) {
                    if ([aChosenCard isKindOfClass:[NSString class]]) {
                        [description appendString:aChosenCard];
                    }
                }
                [description appendString:@" chosen"];
                break;
                
            case 2:
                // match case
                [description appendString:@"Matched "];
                for (NSString *aChosenCard in self.cardsChosen) {
                    if ([aChosenCard isKindOfClass:[NSString class]]) {
                        [description appendString:aChosenCard];
                    }
                }
                [description appendString:[NSString stringWithFormat:@" for %d points!", resultPoints]];
                self.cardsChosen = nil;
                break;
                
            case 3:
                // nomatch case
                for (NSString *aChosenCard in self.cardsChosen) {
                    if ([aChosenCard isKindOfClass:[NSString class]]) {
                        [description appendString:aChosenCard];
                    }
                }
                [description appendString:[NSString stringWithFormat:@" don't match, %d point penalty.", resultPoints]];
                [self updateCardsChosenWithActual];                
                break;
                
            default:
                description = self.cardsChosen[0];
                break;
        }
        self.resultDescription.text = description;
        [self.gameHistoryView addObject:description];
    } else {
        self.resultDescription.text = @"";
        
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Open History"]) {
        if ([segue.destinationViewController isKindOfClass:[GameHistoryViewController class]]) {
            GameHistoryViewController *gameHistoryVC = (GameHistoryViewController *)segue.destinationViewController;
            gameHistoryVC.gameHistory = self.gameHistoryView;
        }
    }
}

@end
