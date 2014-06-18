//
//  CardGameViewController.m
//  Matchismo
//
//  Created by pritish jacob on 5/10/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameSizeSelector;

@end

@implementation CardGameViewController

@synthesize cardsChosen = _cardsChosen;

- (NSMutableArray *)cardsChosen {
    return _cardsChosen ? _cardsChosen : [[NSMutableArray alloc] init];
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

- (void)updateStatusInfo // Abstract
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
        if ([self titleForCard:card] != nil) {
            [self.cardsChosen addObject:[self titleForCard:card]];
        }
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
    [self.cardsChosen removeAllObjects];
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
    [self.cardsChosen removeAllObjects];
    for (UIButton *cardButton in self.cardButtons) {
        unsigned long cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        if (!card.isMatched && card.isChosen) {
            [self.cardsChosen addObject:[self titleForCard:card]];
        }
    }
}

- (void)updateScore {
        self.scoreLabel.text = [NSString stringWithFormat:@"Score %ld", (long)self.game.score];
}

- (void)updateUI {
    [self refreshCardButtonStatus];
    
    [self updateScore];
    
    [self updateStatusInfo];
}



@end
