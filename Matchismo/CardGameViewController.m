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
@end

@implementation CardGameViewController

+ (NSString *)GameOverMessage {
    return @"🙀";
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonAtIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonAtIndex];
    [self updateUI];
}
- (Deck *)createPlayingCardDeck {
    return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *)createTwoCardMatchingGame {
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createPlayingCardDeck]];
}

- (CardMatchingGame *)game {
    if (!_game) _game = [self createTwoCardMatchingGame];
    return _game;
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:(UIControlStateNormal)];
        [cardButton setBackgroundImage: [self backgroundImageForCard:card]
                              forState:(UIControlStateNormal)];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score %d", self.game.score];
        
    }
}


@end
