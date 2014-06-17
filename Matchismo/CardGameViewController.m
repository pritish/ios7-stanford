//
//  CardGameViewController.m
//  Matchismo
//
//  Created by pritish jacob on 5/10/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) CardMatchingGame *game;
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

- (Deck *)createDeck // Abstract
{
    return nil;
}

- (NSUInteger)maxNumberOfCardsAllowedToDraw // Abstract
{
    return 0;
}

- (NSString *)titleForCard:(Card *)card // Abstract
{
    return nil;
}

- (UIImage *)backgroundImageForCard:(Card *)card // Abstract
{
    return nil;
}

- (void)bindUIButtonToCard:(UIButton *)cardButton cardToBind:(Card *)card // Abstract
{
    return;
}

- (CardMatchingGame *)createNCardMatchingGame {
    
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck] numberOfCardsToDraw:[self maxNumberOfCardsAllowedToDraw]];
}

+ (NSString *)GameOverMessage {
    return @"🙀";
}

- (IBAction)touchCardButton:(UIButton *)sender {
    unsigned long chosenButtonAtIndex = [self.cardButtons indexOfObject:sender] ;
    [self.game chooseCardAtIndex:chosenButtonAtIndex];
    Card *card = [self.game cardAtIndex:chosenButtonAtIndex];
    if (card) {
        //self.cardsChosen = [self.cardsChosen stringByAppendingString:[self titleForCard:card]];
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



- (CardMatchingGame *)game {
    if (!_game) _game = [self createNCardMatchingGame];
    return _game;
}


- (void)refreshCardButtonStatus {
    for (UIButton *cardButton in self.cardButtons) {
        unsigned long cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [self bindUIButtonToCard:cardButton cardToBind:card];
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
