//
//  Deck.h
//  Matchismo
//
//  Created by pritish jacob on 5/11/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
