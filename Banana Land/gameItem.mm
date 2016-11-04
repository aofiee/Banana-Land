//
//  coinItem.m
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 4/15/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import "gameItem.h"
#define ARC4RANDOM_MAX 0x100000000

@implementation gameItem
-(id)init
{
    self = [super init];
    if(self != nil)
    {
        itemType = 1;
        state = [[NSMutableString alloc] initWithString:@"ALIVE"];
        CCSpriteFrameCache * frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"itemsPack.plist"];
        CCSpriteBatchNode * spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"itemsPack.png"];

		[self addChild:spriteSheet];
//        [self createItem:frameCache];
    }
    return self;
}
-(int)getItemType
{
    return itemType;
}
-(void)randomItems:(int)n
{
    itemType = n;
    
    switch (n) {
        case 1:
        {
            item = [CCSprite spriteWithSpriteFrameName:@"coin.png"];
            item.anchorPoint = CGPointMake(0.5, 0.5);
            [self addChild:item z:1];
        }
            break;
        case 2:
        {
            item = [CCSprite spriteWithSpriteFrameName:@"banana.png"];
            item.anchorPoint = CGPointMake(0.5, 0.5);
            [self addChild:item z:1];
        }
            break;
        case 3:
        {
            item = [CCSprite spriteWithSpriteFrameName:@"guitar.png"];
            item.anchorPoint = CGPointMake(0.5, 0.5);
            [self addChild:item z:1];
        }
            break;
        case 4:
        {
            item = [CCSprite spriteWithSpriteFrameName:@"heart.png"];
            item.anchorPoint = CGPointMake(0.5, 0.5);
            [self addChild:item z:1];
        }
            break;
        case 5:
        {
            item = [CCSprite spriteWithSpriteFrameName:@"hotdog.png"];
            item.anchorPoint = CGPointMake(0.5, 0.5);
            [self addChild:item z:1];
        }
            break;
        case 6:
        {
            item = [CCSprite spriteWithSpriteFrameName:@"money.png"];
            item.anchorPoint = CGPointMake(0.5, 0.5);
            [self addChild:item z:1];
        }
            break;
        case 7:
        {
            item = [CCSprite spriteWithSpriteFrameName:@"john.png"];
            item.anchorPoint = CGPointMake(0.5, 0.5);
            [self addChild:item z:1];
        }
            break;
        case 8:
        {
            item = [CCSprite spriteWithSpriteFrameName:@"durain.png"];
            item.anchorPoint = CGPointMake(0.5, 0.5);
            [self addChild:item z:1];
        }
            break;
        case 9:
        {
            item = [CCSprite spriteWithSpriteFrameName:@"bomb.png"];
            item.anchorPoint = CGPointMake(0.5, 0.5);
            [self addChild:item z:1];
        }
            break;
        case 10:
        {
            item = [CCSprite spriteWithSpriteFrameName:@"037.png"];
            item.anchorPoint = CGPointMake(0.5, 0.5);
            [self addChild:item z:1];
        }
            break;
        case 11:
        {
            item = [CCSprite spriteWithSpriteFrameName:@"shit.png"];
            item.anchorPoint = CGPointMake(0.5, 0.5);
            [self addChild:item z:1];
        }
            break;
        default:
        {
            item = [CCSprite spriteWithSpriteFrameName:@"coin.png"];
            item.anchorPoint = CGPointMake(0.5, 0.5);
            [self addChild:item z:1];
        }
            break;
    }
    [item runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5.0 angle:360]]];    
}
-(float) getRandomFloatMin:(float)min andMax:(float)max
{
    double val = ((double)arc4random() / ARC4RANDOM_MAX)
    * (max - min)
    + min;
    return val;
}
- (void) changeState:(NSMutableString*)s
{
    [state setString:s];
}
-(void)onEnter{
    [super onEnter];
}
-(void)onExit{
    [super onExit];
    
}
-(void)dealloc
{
    [super dealloc];
}
@end
