//
//  charector.m
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 4/16/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import "charector.h"


@implementation charector
@synthesize actorName;
@synthesize LRM;
-(id)init
{
    self = [super init];
    if(self != nil)
    {
        heart = 4;
        state = [[NSMutableString alloc] initWithString:@"ALIVE"];
        reasonDie = [[NSMutableString alloc] initWithString:@"ALIVE"];
        actorName = [[NSMutableString alloc] initWithString:@"TOY"];
        LRM = [[NSMutableString alloc] initWithString:@"M"];
        
        CCSpriteFrameCache * frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"ac1.plist"];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"ac1.png"];
        [frameCache addSpriteFramesWithFile:@"ac2.plist"];
        CCSpriteBatchNode *spriteSheet2 = [CCSpriteBatchNode batchNodeWithFile:@"ac2.png"];
        [frameCache addSpriteFramesWithFile:@"ac3.plist"];
        CCSpriteBatchNode *spriteSheet3 = [CCSpriteBatchNode batchNodeWithFile:@"ac3.png"];
        [frameCache addSpriteFramesWithFile:@"ac4.plist"];
        CCSpriteBatchNode *spriteSheet4 = [CCSpriteBatchNode batchNodeWithFile:@"ac4.png"];
        [frameCache addSpriteFramesWithFile:@"ac5.plist"];
        CCSpriteBatchNode *spriteSheet5 = [CCSpriteBatchNode batchNodeWithFile:@"ac5.png"];
        [frameCache addSpriteFramesWithFile:@"ac6.plist"];
        CCSpriteBatchNode *spriteSheet6 = [CCSpriteBatchNode batchNodeWithFile:@"ac6.png"];
        [frameCache addSpriteFramesWithFile:@"ac7.plist"];
        CCSpriteBatchNode *spriteSheet7 = [CCSpriteBatchNode batchNodeWithFile:@"ac7.png"];
        [frameCache addSpriteFramesWithFile:@"ac8.plist"];
        CCSpriteBatchNode *spriteSheet8 = [CCSpriteBatchNode batchNodeWithFile:@"ac8.png"];
        [frameCache addSpriteFramesWithFile:@"ac9.plist"];
        CCSpriteBatchNode *spriteSheet9 = [CCSpriteBatchNode batchNodeWithFile:@"ac9.png"];
        [frameCache addSpriteFramesWithFile:@"ac10.plist"];
        CCSpriteBatchNode *spriteSheet10 = [CCSpriteBatchNode batchNodeWithFile:@"ac10.png"];

        [self addChild:spriteSheet z:0];
        [self addChild:spriteSheet2 z:0];
        [self addChild:spriteSheet3 z:0];
        [self addChild:spriteSheet4 z:0];
        [self addChild:spriteSheet5 z:0];
        [self addChild:spriteSheet6 z:0];
        [self addChild:spriteSheet7 z:0];
        [self addChild:spriteSheet8 z:0];
        [self addChild:spriteSheet9 z:0];
        [self addChild:spriteSheet10 z:0];
        
    }
    return self;
}
-(void)setActorDisplay:(NSMutableString *)actor
{
    CCSpriteFrameCache * frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [actorName setString:actor];
    [self createActor:frameCache];
}
-(void)actionLeft
{
    CCSpriteFrameCache * frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    if (![LRM isEqualToString:@"L"]) {
        if (charectorSprite == nil) {
            [self createActor:frameCache];
        }
        [charectorSprite stopActionByTag:1];
        NSMutableArray * actorFrames = [NSMutableArray array];
        for (int i = 2; i<10; i++) {
            [actorFrames addObject:[frameCache spriteFrameByName:[NSString stringWithFormat:@"%@-Left_%d.png",actorName,i]]];
        }
        CCAnimation * runAnima = [CCAnimation
                                  animationWithSpriteFrames:actorFrames delay:0.1f];
        [charectorSprite setDisplayFrame:[frameCache spriteFrameByName:[NSString stringWithFormat:@"%@-Left_1.png",actorName]]];
        charectorSprite.anchorPoint = CGPointMake(0.5, 1);
        
        CCAction * actorAction = [CCRepeatForever actionWithAction:
                                  [CCAnimate actionWithAnimation:runAnima]];
        actorAction.tag = 1;
        [charectorSprite runAction:actorAction];
        [LRM setString:@"L"];
    }
//    NSLog(@"%@",LRM);
}
-(void)actionRight
{
    CCSpriteFrameCache * frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    if (![LRM isEqualToString:@"R"]) {
        if (charectorSprite == nil) {
            [self createActor:frameCache];
        }
        [charectorSprite stopActionByTag:1];
        NSMutableArray * actorFrames = [NSMutableArray array];
        for (int i = 2; i<10; i++) {
            [actorFrames addObject:[frameCache spriteFrameByName:[NSString stringWithFormat:@"%@-Right_%d.png",actorName,i]]];
        }
        CCAnimation * runAnima = [CCAnimation
                                  animationWithSpriteFrames:actorFrames delay:0.1f];
        [charectorSprite setDisplayFrame:[frameCache spriteFrameByName:[NSString stringWithFormat:@"%@-Left_1.png",actorName]]];
        charectorSprite.anchorPoint = CGPointMake(0.5, 1);
        
        CCAction * actorAction = [CCRepeatForever actionWithAction:
                                  [CCAnimate actionWithAnimation:runAnima]];
        actorAction.tag = 1;
        [charectorSprite runAction:actorAction];
        [LRM setString:@"R"];
    }
//    NSLog(@"%@",LRM);
}
-(void)createActor:(CCSpriteFrameCache*)frameCache
{
    NSMutableArray * actorFrames = [NSMutableArray array];
    for (int i = 2; i<10; i++) {
        [actorFrames addObject:[frameCache spriteFrameByName:[NSString stringWithFormat:@"%@-Mid_%d.png",actorName,i]]];
    }
    CCAnimation * runAnima = [CCAnimation
                              animationWithSpriteFrames:actorFrames delay:0.1f];
    charectorSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@-Mid_1.png",actorName]];
    charectorSprite.anchorPoint = CGPointMake(0.5, 1);
    [self addChild:charectorSprite z:1];
    
    CCAction * actorAction = [CCRepeatForever actionWithAction:
                              [CCAnimate actionWithAnimation:runAnima]];
    actorAction.tag = 1;
    [charectorSprite runAction:actorAction];
}
- (void) changeState:(NSMutableString*)s
{
    [state setString:s];
    
    if ([state isEqualToString:@"DEATH"]) {

        CCSequence * deathAction = [CCSequence actions:
                                    [CCMoveTo actionWithDuration:0.3 position:ccp(charectorSprite.position.x, charectorSprite.position.y+160)],
                                    [CCMoveTo actionWithDuration:0.3 position:ccp(charectorSprite.position.x,charectorSprite.position.y-190)],
                                    [CCCallFunc actionWithTarget:self selector:@selector(changeDeathFinish)],
                                    nil];
        [charectorSprite runAction:deathAction];
    }
}
-(void)changeDeathFinish
{
    [self changeState:[NSMutableString stringWithString:@"GAMEOVER"]];
}
@end
