//
//  PlayingCardView.h
//  Matchismo
//
//  Created by pritish jacob on 6/29/14.
//  Copyright (c) 2014 pritish jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

@end
