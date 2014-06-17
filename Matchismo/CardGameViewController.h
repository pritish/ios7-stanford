//
//  CardGameViewController.h
//  Matchismo
//
//  Created by pritish jacob on 5/10/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//
// Abstract class - implement methods below

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

// protected
// for subclasses to implement
- (Deck *)createDeck; // Abstract
- (NSUInteger)maxNumberOfCardsAllowedToDraw; // Abstract
- (NSString *)titleForCard:(Card *)card; // Abstract
- (UIImage *)backgroundImageForCard:(Card *)card; // Abstract
- (void)bindUIButtonToCard:(UIButton *)cardButton cardToBind:(Card *)card; // Abstract

@end
