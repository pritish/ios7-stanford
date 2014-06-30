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
@property (weak, nonatomic) IBOutlet UILabel *resultDescription;

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

- (NSAttributedString *)titleForCard:(Card *)card {
    return card.isChosen ? [self getAttributedTitleForCard:card] : nil;
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"setgameBack" : @"cardfront"];
}

- (NSAttributedString *)getAttributedTitleForCard:(Card *)card {
    if ([card isKindOfClass:[TheSetCard class]]) {
        TheSetCard *aSetCard = (TheSetCard *)card;
        NSMutableString *unstyledTitle = [[NSMutableString alloc] init];
        
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        //@"▲", @"●", @"■" we could store these in a property if we wanted the viewcontroller to allows playing Set with any three distinct shapes
        for (int i=0; i<aSetCard.numberOfSymbols; i++) {
            if ([aSetCard.symbol caseInsensitiveCompare:@"circle"] == NSOrderedSame) {
                [unstyledTitle appendString:@"●"];
            } else if ([aSetCard.symbol caseInsensitiveCompare:@"square"] == NSOrderedSame) {
                [unstyledTitle appendString:@"■"];
            } else if ([aSetCard.symbol caseInsensitiveCompare:@"triangle"] == NSOrderedSame) {
                [unstyledTitle appendString:@"▲"];
            }
        }
        
        if ([aSetCard.color caseInsensitiveCompare:@"green"] == NSOrderedSame) {
            [attributes setObject:[UIColor greenColor]
                           forKey:NSForegroundColorAttributeName];
        } else if ([aSetCard.color caseInsensitiveCompare:@"red"] == NSOrderedSame) {
            [attributes setObject:[UIColor redColor]
                           forKey:NSForegroundColorAttributeName];
        } else if ([aSetCard.color caseInsensitiveCompare:@"purple"] == NSOrderedSame) {
            [attributes setObject:[UIColor purpleColor]
                           forKey:NSForegroundColorAttributeName];
        }
        
        if ([aSetCard.shading caseInsensitiveCompare:@"striped"] == NSOrderedSame) {
            //[attributes setObject:@3 forKey:NSStrokeWidthAttributeName];
            [attributes setObject:[attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.2f] forKey:NSForegroundColorAttributeName];
            [attributes setObject:@0 forKey:NSStrokeWidthAttributeName];
            
        } else if ([aSetCard.shading caseInsensitiveCompare:@"solid"] == NSOrderedSame) {
            [attributes setObject:@-3 forKey:NSStrokeWidthAttributeName];
        } else if ([aSetCard.shading caseInsensitiveCompare:@"open"] == NSOrderedSame) {
            [attributes setObject:@6 forKey:NSStrokeWidthAttributeName];
        }
        
        return [[NSAttributedString alloc] initWithString:unstyledTitle attributes:attributes];
    }
    else return nil;
}

- (void)bindUIButtonToCard:(UIButton *)cardButton cardToBind:(Card *)card {
        [cardButton setAttributedTitle:[self getAttributedTitleForCard:card] forState:(UIControlStateNormal)];
        [cardButton setBackgroundImage: [self backgroundImageForCard:card]
                              forState:(UIControlStateNormal)];
        cardButton.enabled = !card.isMatched;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateStatusInfo {

    
    id lastEventObj = [self.game.gameHistory lastObject];
    if ([lastEventObj isKindOfClass:[NSString class]]) {
        //@[@"unchosen", @"chosen", @"match", @"mismatch"]
        NSString *lastEvent = (NSString *)lastEventObj;
        NSArray *lastEventParsed = [lastEvent componentsSeparatedByString:@","];
        unsigned long resultType = [[CardMatchingGame GameEventTypes] indexOfObject:[(NSString *)[lastEventParsed objectAtIndex:0] lowercaseString] ];
        int resultPoints = [[lastEventParsed objectAtIndex:1] intValue];
        NSMutableAttributedString *description = [[NSMutableAttributedString alloc] init];
        
        switch (resultType) {
            case 0:
                // unchosen case
                for (NSAttributedString *aChosenCard in self.cardsChosen) {
                    if ([aChosenCard isKindOfClass:[NSAttributedString class]]) {
                        [description appendAttributedString:aChosenCard];
                    }
                }
                [description appendAttributedString:[[NSAttributedString alloc] initWithString:@" unchosen"]];
                
                self.resultDescription.attributedText = description;
                [self.gameHistoryView addObject:description];
                self.cardsChosen = nil;
                break;
                
            case 1:
                // chosen case
                for (NSAttributedString *aChosenCard in self.cardsChosen) {
                    if ([aChosenCard isKindOfClass:[NSAttributedString class]]) {
                        [description appendAttributedString:aChosenCard];
                    }
                }
                [description appendAttributedString:[[NSAttributedString alloc] initWithString:@" chosen"]];
                
                self.resultDescription.attributedText = description;
                [self.gameHistoryView addObject:description];
                break;
                
            case 2:
                // match case
                [description appendAttributedString:[[NSAttributedString alloc] initWithString:@"Set: "]];
                for (NSAttributedString *aChosenCard in self.cardsChosen) {
                    if ([aChosenCard isKindOfClass:[NSAttributedString class]]) {
                        [description appendAttributedString:aChosenCard];
                    }
                }
                [description appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"confirmed for %d points.", resultPoints]]];
                
                self.resultDescription.attributedText = description;
                [self.gameHistoryView addObject:description];
                self.cardsChosen = nil;
                break;
                
            case 3:
                // nomatch case
                for (NSAttributedString *aChosenCard in self.cardsChosen) {
                    if ([aChosenCard isKindOfClass:[NSAttributedString class]]) {
                        [description appendAttributedString:aChosenCard];
                    }
                }
                [description appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %d point penalty!", resultPoints]]];
                
                self.resultDescription.attributedText = description;
                [self.gameHistoryView addObject:description];
                [self updateCardsChosenWithActual];
                
                break;
                
            default:
                if (self.cardsChosen != nil) {
                    self.resultDescription.attributedText = self.cardsChosen[0];
                    [self.gameHistoryView addObject:self.cardsChosen[0]];
                }
                break;
        }
    } else {
        self.resultDescription.text = @"";
        
    }
}

@end
