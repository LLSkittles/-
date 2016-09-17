//
//  Card.m
//  德州扑克
//
//  Created by Chao on 16/9/13.
//  Copyright © 2016年 Chao. All rights reserved.
//

#import "Card.h"

const NSString *CARD_NAME[] =
{
    @"spades", @"hearts", @"clubs", @"diamonds"
};

@interface Card ()

@property (nonatomic, strong) CCSprite *backCard;
@property (nonatomic, strong) CCSprite *frontCard;


@end


@implementation Card

+ (Card *)copyCard:(Card *)card{
    
    Card *same = [[Card alloc] initWithType:card.type andNumber:card.number isBack:NO];
    same.scale = 0.5;
    
    return same;
}

- (id)initWithType:(cardType)type andNumber:(NSString *)number isBack:(BOOL)bBack{

    CCSprite *temp = [[CCSprite alloc] initWithImageNamed:[NSString stringWithFormat:@"spades.%ld.png", (unsigned long)2]];
    
    self = [super initWithColor:[CCColor clearColor] width:temp.boundingBox.size.width height:temp.boundingBox.size.height];
    
    NSString *str = [NSString stringWithFormat:@"%@.%@.png", CARD_NAME[type], number];
    _frontCard = [[CCSprite alloc] initWithImageNamed:str];
    _frontCard.position = CGPointMake(temp.boundingBox.size.width / 2, temp.boundingBox.size.height / 2);
    [self addChild:_frontCard];
    
    _number = number;
    _type = type;
    _isBack = bBack;
    
    if (bBack) {
        
        _frontCard.scaleX = 0;
        
        _backCard = [[CCSprite alloc] initWithImageNamed:[NSString stringWithFormat:@"back.blue.png"]];
        _backCard.position = _frontCard.position;
        [self addChild:_backCard];
    }
 
//    self.userInteractionEnabled = YES;
    
    return self;
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    
    

}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    
    if (_isBack) {
        
        CCActionScaleTo *backScale = [CCActionScaleTo actionWithDuration:0.3 scaleX:0 scaleY:1];
        
        CCActionCallBlock *callBack = [CCActionCallBlock actionWithBlock:^{
            
            CCActionScaleTo *frontScale = [CCActionScaleTo actionWithDuration:0.3 scaleX:1 scaleY:1];
            [_frontCard runAction:frontScale];
        }];
        
        CCActionSequence *sequence = [CCActionSequence actionWithArray:@[backScale, callBack]];
        
        [_backCard runAction:sequence];
        
        _isBack = NO;
    }
}

- (void)setFrontWithAnimation:(BOOL)b{
    
    if (b && _isBack) {
        
        CCActionScaleTo *backScale = [CCActionScaleTo actionWithDuration:0.3 scaleX:0 scaleY:1];
        
        CCActionCallBlock *callBack = [CCActionCallBlock actionWithBlock:^{
            
            CCActionScaleTo *frontScale = [CCActionScaleTo actionWithDuration:0.3 scaleX:1 scaleY:1];
            [_frontCard runAction:frontScale];
        }];
        
        CCActionSequence *sequence = [CCActionSequence actionWithArray:@[backScale, callBack]];
        
        [_backCard runAction:sequence];
            
    }else{
        
        _backCard.scale = 0;
        _frontCard.scale = 1;
    }
    
    _isBack = NO;
}

@end
