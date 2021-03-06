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
@synthesize gameHistoryView = _gameHistoryView;

- (NSArray *)cardsChosen {
    return _cardsChosen ? _cardsChosen : [[NSArray alloc] init];
}

- (CardMatchingGame *)game {
    if (!_game) _game = [self createNCardMatchingGame];
    return _game;
}


- (NSMutableArray *)gameHistoryView {
    if (!_gameHistoryView) _gameHistoryView = [[NSMutableArray alloc] init];
    return _gameHistoryView;
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
            self.cardsChosen = [self.cardsChosen arrayByAddingObject:[self titleForCard:card]];
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
    self.cardsChosen = nil;
    [self.gameHistoryView addObject:[[NSAttributedString alloc] initWithString:@"GAME RESTARTED" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}]];
    [self updateUI];
}





- (void)refreshCardButtonStatus {
    for (UIButton *cardButton in self.cardButtons) {
        unsigned long cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [self bindUIButtonToCard:cardButton cardToBind:card];
    }
}

- (void)updateCardsChosenWithActual {
    self.cardsChosen = nil;
    for (UIButton *cardButton in self.cardButtons) {
        unsigned long cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        if (!card.isMatched && card.isChosen) {
            self.cardsChosen = [self.cardsChosen arrayByAddingObject:[self titleForCard:card]];
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
