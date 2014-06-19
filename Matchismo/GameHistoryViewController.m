//
//  GameHistoryViewController.m
//  Matchismo
//
//  Created by pritish jacob on 6/19/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "GameHistoryViewController.h"

@interface GameHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *body;

@end

@implementation GameHistoryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (void)updateUI
{
    NSMutableAttributedString *oneLongDescription = [[NSMutableAttributedString alloc] init];
    for (id aGameEntry in self.gameHistory) {
        if ([aGameEntry isKindOfClass:[NSAttributedString class]]) {
            [oneLongDescription appendAttributedString:(NSAttributedString *)aGameEntry];
            [oneLongDescription appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        } else if ([aGameEntry isKindOfClass:[NSString class]]) {
            [oneLongDescription appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", (NSString *)aGameEntry]]];
        }
    }
    
    if (oneLongDescription != nil ) {
        self.body.attributedText = oneLongDescription;
    }
}

- (void)setGameHistory:(NSArray *)gameHistory {
    _gameHistory = gameHistory;
    [self updateUI];
}
@end
