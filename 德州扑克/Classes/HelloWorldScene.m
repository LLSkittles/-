//
//  HelloWorldScene.m
//
//  Created by : Chao
//  Project    : 德州扑克
//  Date       : 16/9/11
//
//  Copyright (c) 2016年 Chao.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "HelloWorldScene.h"
#import "Player.h"
#import "Card.h"
#import "CardsManager.h"
#import "judgeManager.h"
#import "ResultListSprite.h"

@interface HelloWorldScene ()

@property (nonatomic, strong) NSMutableArray *commonCards;
@property (nonatomic, strong) Player *player1;
@property (nonatomic, strong) Player *player2;
@property (nonatomic, strong) ResultListSprite *result1;
@property (nonatomic, strong) ResultListSprite *result2;

@property (nonatomic, strong) CCLabelTTF       *win;

@end

@implementation HelloWorldScene


- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    
    // The thing is, that if this fails, your app will 99.99% crash anyways, so why bother
    // Just make an assert, so that you can catch it in debug
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cards.classic.plist"];
    CGSize visiableSize = [[CCDirector sharedDirector] viewSize];

    CCButton *fanpai = [CCButton buttonWithTitle:@"翻牌"];
    fanpai.position = CGPointMake(visiableSize.width - 40, 20);
    [self addChild:fanpai];
    [fanpai setTarget:self selector:@selector(fanpai)];
    
    CCButton *fapai = [CCButton buttonWithTitle:@"发牌"];
    fapai.position = CGPointMake(visiableSize.width - 80, 20);
    [self addChild:fapai];
    [fapai setTarget:self selector:@selector(fapai)];
    
    CCNodeColor *backColor1 = [[CCNodeColor alloc] initWithColor:[CCColor brownColor] width:73 * 2 height:98];
    backColor1.anchorPoint = CGPointZero;
    backColor1.position = CGPointMake((visiableSize.width - 73 * 2) / 2, 5);;
    [self addChild:backColor1];
    
    CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"Play1:" fontName:@"ArialMT" fontSize:16];
    label1.fontColor = [CCColor whiteColor];
    label1.position = (CGPoint){180, 20};
    [self addChild:label1];
    
    CCNodeColor *backColor2 = [[CCNodeColor alloc] initWithColor:[CCColor brownColor] width:73 * 2 height:98];
    backColor2.anchorPoint = CGPointZero;
    backColor2.position = CGPointMake((visiableSize.width - 73 * 2) / 2, visiableSize.height - 100);;
    [self addChild:backColor2];
    
    CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Play2:" fontName:@"ArialMT" fontSize:16];
    label2.fontColor = [CCColor whiteColor];
    label2.position = (CGPoint){180, visiableSize.height - 20};
    [self addChild:label2];
    
    self.win = [CCLabelTTF labelWithString:@"" fontName:@"ArialMT" fontSize:16];
    self.win.position = CGPointMake(visiableSize.width - 40, visiableSize.height / 2);
    [self addChild:self.win];

    return self;
}

- (NSInteger)hexToInt:(NSString *)hexStr{
    
    unsigned long long result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner scanHexLongLong:&result];
    
    return result;
}

- (void)fapai{
    
    CGSize visiableSize = [[CCDirector sharedDirector] viewSize];
    [self.player1 removeFromParent];
    [self.player2 removeFromParent];
    [self.result1 removeFromParent];
    [self.result2 removeFromParent];
    self.win.string = @"";
    
    [[CardsManager shareInstance] reset];
    
    self.player1 = [[Player alloc] init];
    self.player1.anchorPoint = CGPointZero;
    self.player1.position = CGPointMake((visiableSize.width - 73 * 2) / 2, 5);
    [self addChild:_player1];
    
    self.player2 = [[Player alloc] init];
    self.player2.anchorPoint = CGPointZero;
    self.player2.position = CGPointMake((visiableSize.width - 73 * 2) / 2, visiableSize.height - 100);
    [self addChild:_player2];
    
    for (int i = 0;i < self.commonCards.count; i++) {
        
        [self removeChild:self.commonCards[i]];
    }
    
    if (!self.commonCards) {
        
        self.commonCards = [[NSMutableArray alloc] initWithCapacity:5];
    
    }else{
        
        [self.commonCards removeAllObjects];
    }
    
    for (int i = 0; i < 5; i++) {
        
        Card *card = [[CardsManager shareInstance] getRandomCard];
        card.anchorPoint = CGPointZero;
        card.position = CGPointMake(0, visiableSize.height / 2 - 45);
        [self.commonCards addObject:card];
        [self addChild:card];
        
        CCActionMoveTo *moveto = [CCActionMoveTo actionWithDuration:0.5 position:CGPointMake(103 + i * card.boundingBox.size.width , visiableSize.height / 2 - 45)];
        [card runAction:moveto];
    }
}

- (void)fanpai{
    
    if (self.commonCards == nil || ![self.commonCards[4] isBack]) {
        
        return;
    }
    
    if ([self.commonCards[0] isBack]) {
        
        for (int i = 0; i < 3; i++) {
            
            Card *card = self.commonCards[i];
            [card setFrontWithAnimation:YES];
        }
        
    }else if (![self.commonCards[2] isBack] && [self.commonCards[3] isBack]) {
        
        Card *card = self.commonCards[3];
        [card setFrontWithAnimation:YES];
    
    }else if(![self.commonCards[3] isBack]){
        
        Card *card = self.commonCards[4];
        [card setFrontWithAnimation:YES];
        
        [self performSelector:@selector(judgeGame) withObject:nil afterDelay:0.8];
    }
}

- (void)judgeGame{
    
    NSArray *resultSets = [[self getLargestList:[_player1 getBaseCards]] objectAtIndex:1];
    NSString *type1 = [[self getLargestList:[_player1 getBaseCards]] objectAtIndex:0];
    NSInteger value1 = [self hexToInt:type1];
    self.result1 = [[ResultListSprite alloc] initWithResultSet:resultSets];
    self.result1.position = CGPointMake(5, 10);
    
    [self addChild:self.result1];
    
    
    NSArray *resultSets2 = [[self getLargestList:[_player2 getBaseCards]] objectAtIndex:1];
    NSString *type2 = [[self getLargestList:[_player2 getBaseCards]] objectAtIndex:0];
    NSInteger value2 = [self hexToInt:type2];
    self.result2 = [[ResultListSprite alloc] initWithResultSet:resultSets2];
    self.result2.position = CGPointMake(5, 200);
    
    [self addChild:self.result2];
    
    if (value1 > value2) {
        
        self.win.string = @"play1 win";
    }else if (value1 < value2){
        
        self.win.string = @"play2 win";
    }else{
     
        self.win.string = @"equal";
    }
}

- (NSArray *)getLargestList:(NSArray *)playerCards{
    
    NSMutableArray *allSets = [self getSubSets]; // C(5, 3)
    NSMutableArray *allValues = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (NSArray *arr in allSets) {
        
        NSMutableArray *a = [[NSMutableArray alloc] initWithArray:arr];
        [a addObjectsFromArray:playerCards];
        
        [allValues addObject:a];
    }
    
    NSString *type = [judgeManager juageCardsType:allValues[0]];
    NSInteger result = [self hexToInt:type];
    NSArray *resultSet = allValues[0];
    
    for (NSMutableArray *set in allValues) {
        
        NSString *temp = [judgeManager juageCardsType:set];
        NSInteger value = [self hexToInt:temp];
        if (result < value) {
            
            result = value;
            type = temp;
            resultSet = [set copy];
        }
    }

    return @[type, resultSet];
}


- (NSMutableArray *)getSubSets{
    
    NSMutableArray *subSets = [NSMutableArray array];//结果
    NSMutableArray *list = [NSMutableArray array];//每次递归的子集
    int pos = 0;//保证子集升序排列
    [self subsetsHelper:subSets list:list nums:self.commonCards postion:pos];
    
    return subSets;
}

- (void)subsetsHelper:(NSMutableArray<NSMutableArray *> *)result
                 list:(NSMutableArray *)list
                 nums:(NSArray *)nums
              postion:(int)pos {
    if (list.count == 3) {
        
        [result addObject:[list mutableCopy]];
    }
    for (int i = pos; i < nums.count; i++) {
        [list addObject:nums[i]];
        [self subsetsHelper:result list:list nums:nums postion:i + 1];
        [list removeObjectAtIndex:list.count - 1];
    }
}

@end























// why not add a few extra lines, so we dont have to sit and edit at the bottom of the screen ...
