//
//  TheSetCard.h
//  Matchismo
//
//  Created by pritish jacob on 6/16/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import "Card.h"

@interface TheSetCard : Card

@property (strong, nonatomic) NSString *symbol;
@property (nonatomic) NSUInteger numberOfSymbols;
@property (strong, nonatomic) NSNumber *shadingStroke;
@property (strong, nonatomic) NSString *color;


+ (NSArray *)validSymbols;
+ (NSUInteger)maxNumberOfSymbols;
+ (NSArray *)validColors;
+ (NSArray *)validShadingStrokes;

@end
