//
//  CardGameViewController.m
//  Matchismo
//
//  Created by pritish jacob on 5/10/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameSizeSelector;
@property (weak, nonatomic) IBOutlet UILabel *resultDescription;
@property (strong, nonatomic) NSString *cardsChosen;

@end

@implementation CardGameViewController

@synthesize cardsChosen = _cardsChosen;

- (NSString *)cardsChosen {
    return _cardsChosen ? _cardsChosen : [[NSString alloc] init];
}

+ (NSString *)GameOverMessage {
    return @"🙀";
}

- (IBAction)touchCardButton:(UIButton *)sender {
    unsigned long chosenButtonAtIndex = [self.cardButtons indexOfObject:sender] ;
    [self.game chooseCardAtIndex:chosenButtonAtIndex];
    Card *card = [self.game cardAtIndex:chosenButtonAtIndex];
    if (card) {
        self.cardsChosen = [self.cardsChosen stringByAppendingString:[self titleForCard:card]];
    }
    
    [self updateUI];
}

- (IBAction)touchGameSizeSelector:(UISegmentedControl *)sender {
    self.game.maxCardsToDraw = (NSUInteger)[[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]] integerValue];
}

- (IBAction)touchRestartButton:(UIButton *)sender {
    // reset the game, update the UI
    self.game = [self createNCardMatchingGame];
    self.gameSizeSelector.enabled=true;
    self.cardsChosen = @"";
    [self updateUI];
}

- (Deck *)createPlayingCardDeck {
    return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *)createNCardMatchingGame {
    
    
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createPlayingCardDeck] numberOfCardsToDraw:(NSUInteger)[[self.gameSizeSelector titleForSegmentAtIndex:[self.gameSizeSelector selectedSegmentIndex]] integerValue]];
}

- (CardMatchingGame *)game {
    if (!_game) _game = [self createNCardMatchingGame];
    return _game;
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)refreshCardButtonStatus {
    for (UIButton *cardButton in self.cardButtons) {
        unsigned long cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:(UIControlStateNormal)];
        [cardButton setBackgroundImage: [self backgroundImageForCard:card]
                              forState:(UIControlStateNormal)];
        cardButton.enabled = !card.isMatched;
    }
}

- (void)updateCardsChosenWithActual {
    self.cardsChosen = @"";
    for (UIButton *cardButton in self.cardButtons) {
        unsigned long cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        if (!card.isMatched && card.isChosen) {
            self.cardsChosen = [self.cardsChosen stringByAppendingString:[self titleForCard:card]];
        }
    }
}

- (void)updateStatusInfo {
    self.scoreLabel.text = [NSString stringWithFormat:@"Score %ld", (long)self.game.score];
    
    id lastEventObj = [self.game.gameHistory lastObject];
    if ([lastEventObj isKindOfClass:[NSString class]]) {
        //@[@"unchosen", @"chosen", @"match", @"mismatch"]
        NSString *lastEvent = (NSString *)lastEventObj;
        NSArray *lastEventParsed = [lastEvent componentsSeparatedByString:@","];
        unsigned long resultType = [[CardMatchingGame GameEventTypes] indexOfObject:[(NSString *)[lastEventParsed objectAtIndex:0] lowercaseString] ];
        int resultPoints = [[lastEventParsed objectAtIndex:1] intValue];
        switch (resultType) {
            case 0:
                // unchosen case
                self.resultDescription.text = [NSString stringWithFormat:@"%@ unchosen", self.cardsChosen];
                self.cardsChosen = @"";
                break;
                
            case 1:
                // chosen case
                self.resultDescription.text = [NSString stringWithFormat:@"%@ chosen", self.cardsChosen];
                break;
                
            case 2:
                // match case
                self.resultDescription.text = [NSString stringWithFormat:@"Matched %@ for %d points.", self.cardsChosen, resultPoints];
                self.cardsChosen = @"";
                break;
                
            case 3:
                // nomatch case
                self.resultDescription.text = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", self.cardsChosen, resultPoints];
                [self updateCardsChosenWithActual];

                break;
                
            default:
                
                self.resultDescription.text = self.cardsChosen;
                break;
        }
    } else {
        self.resultDescription.text = self.cardsChosen;
        
    }
}

- (void)updateUI {
    [self refreshCardButtonStatus];
    
    [self updateStatusInfo];
}



@end
