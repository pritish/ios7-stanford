//
//  CardGameViewController.m
//  Matchismo
//
//  Created by pritish jacob on 5/10/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck *deck;

@end

@implementation CardGameViewController

+ (NSString *)GameOverMessage {
    return @"🙀";
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flipCount changed to %d", self.flipCount);
}

- (IBAction)touchCardButton:(UIButton *)sender {
    if ([sender.currentTitle length] || [sender.currentTitle isEqualToString:[CardGameViewController GameOverMessage]]){
        [sender setBackgroundImage:[UIImage imageNamed:@"cardback"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    } else {
        Card *aRandomCard = [self.deck drawRandomCard];
        if (aRandomCard) {
            [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"]
                              forState:UIControlStateNormal];
            [sender setTitle:[aRandomCard contents] forState:UIControlStateNormal];
            self.flipCount++;
        } else {
            NSArray *imageArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"gameover1" ], [UIImage imageNamed:@"gameover2"], nil];
            [sender setBackgroundImage:[UIImage animatedImageWithImages:imageArray
                                                               duration:0.5f]
                              forState:UIControlStateNormal];
            [sender setTitle:[CardGameViewController GameOverMessage]
                    forState:UIControlStateNormal];
        }
    }
}

- (Deck *)deck {
    if (!_deck) _deck = [self createPlayingCardDeck];
    return _deck;
}

- (Deck *)createPlayingCardDeck {
    return [[PlayingCardDeck alloc] init];
}

@end
