//
//  gameOverScene.m
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 4/18/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import "gameOverScene.h"
#import "AppDelegate.h"
#import "menuScene.h"
#import <FacebookSDK/FacebookSDK.h>
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@implementation gameOverScene
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	gameOverScene *layer = [gameOverScene node];
	[scene addChild: layer];
	return scene;
}
-(id) init
{
	if( (self=[super init])) {

        
        CCSpriteFrameCache * frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"loading.plist"];
        [frameCache addSpriteFramesWithFile:@"die1.plist"];
        [frameCache addSpriteFramesWithFile:@"die2.plist"];
        [frameCache addSpriteFramesWithFile:@"die3.plist"];
        [frameCache addSpriteFramesWithFile:@"die4.plist"];
        [frameCache addSpriteFramesWithFile:@"die5.plist"];
        [frameCache addSpriteFramesWithFile:@"die6.plist"];
        [frameCache addSpriteFramesWithFile:@"die7.plist"];
        [frameCache addSpriteFramesWithFile:@"die8.plist"];
        [frameCache addSpriteFramesWithFile:@"die9.plist"];
        [frameCache addSpriteFramesWithFile:@"die10.plist"];
        [frameCache addSpriteFramesWithFile:@"die11.plist"];
        [frameCache addSpriteFramesWithFile:@"die12.plist"];
        [frameCache addSpriteFramesWithFile:@"die13.plist"];
        [frameCache addSpriteFramesWithFile:@"die14.plist"];
        [frameCache addSpriteFramesWithFile:@"die15.plist"];
        [frameCache addSpriteFramesWithFile:@"die16.plist"];
        [frameCache addSpriteFramesWithFile:@"die17.plist"];
        [frameCache addSpriteFramesWithFile:@"die18.plist"];
        
        bg = nil;
        if (IS_IPHONE5) {
            bg = [CCSprite spriteWithFile:@"gameOver-i5.png"];
        }else{
            bg = [CCSprite spriteWithFile:@"gameOver-i4.png"];
        }
        CGSize size = [[CCDirector sharedDirector] winSize];
        bg.anchorPoint = CGPointMake(0.5, 0.5);
        bg.position = ccp(size.width/2, size.height/2);
        [self addChild:bg z:0];
        


	}
	
	return self;
}
-(void)createdHumanDie
{
    NSString * humanName = nil;
    NSDictionary * userDefault = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSString * s = [userDefault objectForKey:@"bananaland_session_playerSelected"];

    if ([s isEqualToString:@"ART"]) {humanName = @"ART";}
    if ([s isEqualToString:@"BON"]) {humanName = @"Bon";}
    if ([s isEqualToString:@"BRYAN"]) {humanName = @"Bryan";}
    if ([s isEqualToString:@"Cowboy"]) {humanName = @"Cowboy";}
    if ([s isEqualToString:@"Eskimo"]) {humanName = @"Eskimo";}
    if ([s isEqualToString:@"InVein"]) {humanName = @"InVein";}
    if ([s isEqualToString:@"Jane"]) {humanName = @"JANE";}
    if ([s isEqualToString:@"Jaroen"]) {humanName = @"Jaroen";}
    if ([s isEqualToString:@"JOHN"]) {humanName = @"John";}
    if ([s isEqualToString:@"Joke"]) {humanName = @"Joke";}
    if ([s isEqualToString:@"KAN"]) {humanName = @"KAN";}
    if ([s isEqualToString:@"Nay"]) {humanName = @"NAY";}
    if ([s isEqualToString:@"Paul"]) {humanName = @"PAUL";}
    if ([s isEqualToString:@"Pound"]) {humanName = @"Pound";}
    if ([s isEqualToString:@"Tor"]) {humanName = @"TOR";}
    if ([s isEqualToString:@"Toy"]) {humanName = @"TOY";}
    if ([s isEqualToString:@"TUM"]) {humanName = @"TUM";}
    if ([s isEqualToString:@"Edit-Walnut"]) {humanName = @"WALNUT";}
    
    CCSpriteFrameCache * frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    CGSize size = [[CCDirector sharedDirector]winSize];
    NSMutableArray * actorFrames = [NSMutableArray array];
    for (int i = 6; i<10; i++) {
        [actorFrames addObject:[frameCache spriteFrameByName:[NSString stringWithFormat:@"%@_%02d.png",humanName,i]]];
    }
    CCAnimation * runAnima = [CCAnimation
                              animationWithSpriteFrames:actorFrames delay:0.1f];
    CCSprite * charectorSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_05.png",humanName]];
    charectorSprite.anchorPoint = CGPointMake(0, 0.5);
    float human_x,human_y;
    if (IS_OS_7_OR_LATER) {
        human_x = 0;
        human_y = size.height/2;
    }else{
        if([self isRetina])
        {
            NSLog(@"new ipad");
            human_x = 0;
            human_y = size.height/2;
        }else{
            NSLog(@"old ipad");
            human_x = 200;
            human_y = size.height;
        }
    }
    charectorSprite.position = ccp(human_x, human_y);
    [bg addChild:charectorSprite z:1];
    
    CCAction * actorAction = [CCRepeatForever actionWithAction:
                              [CCAnimate actionWithAnimation:runAnima]];
    actorAction.tag = 1;
    [charectorSprite runAction:actorAction];
}
- (BOOL)isRetina
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0) {
        return YES;
    }
    return NO;
}
-(void)onEnter
{
    [super onEnter];
    [self createdHumanDie];
    CGSize size = [[CCDirector sharedDirector] winSize];
    float scoreTable_x,scoreTable_y;
    float scoreTotal_x,scoreTotal_y;
    float levelTotal_x,levelTotal_y;
    float playAgain_x,playAgain_y;
    
        CCLabelTTF * scoreTable = [CCLabelTTF labelWithString:@"สรุปคะแนน" fontName:@"SP Aftershock" fontSize:26];
        scoreTable.anchorPoint  = CGPointMake(0, 0);
        if (IS_OS_7_OR_LATER) {
            scoreTable_x = ((size.width/2)+((size.width/2)/2))-(scoreTable.contentSize.width/2);
            scoreTable_y = size.height-100;
        }else{
            if ([self isRetina]) {
                scoreTable_x = ((size.width/2)+((size.width/2)/2))-(scoreTable.contentSize.width/2);
                scoreTable_y = size.height-100;
            }else{
                scoreTable_x = size.width+((size.width/2)/2)-(scoreTable.contentSize.width/2);
                scoreTable_y = size.height+100;
            }
        }
        scoreTable.position = ccp(scoreTable_x,scoreTable_y);
        scoreTable.color = ccc3(255,255,255);
        [bg addChild:scoreTable z:10];
        
        AppController * app = (AppController *)[[UIApplication sharedApplication] delegate];
        int score = [app getScore];
        int level = [app getLevel];

        CCLabelTTF * scoreTotal = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"คะแนนรวม: %d",score] fontName:@"SP Aftershock" fontSize:26];
        scoreTotal.anchorPoint  = CGPointMake(0, 0);
        if (IS_OS_7_OR_LATER) {
            scoreTotal_x = (size.width/2)+20;
            scoreTotal_y = size.height-140;
        }else{
            if ([self isRetina]) {
                scoreTotal_x = (size.width/2)+20;
                scoreTotal_y = size.height-140;
            }else{
                scoreTotal_x = size.width+20;
                scoreTotal_y = size.height+60;
            }
        }
        scoreTotal.position = ccp(scoreTotal_x,scoreTotal_y);
        scoreTotal.color = ccc3(255,255,255);
        [bg addChild:scoreTotal z:10];
        
        CCLabelTTF * levelTotal = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"level: %d",level] fontName:@"SP Aftershock" fontSize:26];
        levelTotal.anchorPoint  = CGPointMake(0, 0);
        if (IS_OS_7_OR_LATER) {
            levelTotal_x = (size.width/2)+20;
            levelTotal_y = size.height-160;
        }else{
            if ([self isRetina]) {
                levelTotal_x = (size.width/2)+20;
                levelTotal_y = size.height-160;
            }else{
                levelTotal_x = size.width+20;
                levelTotal_y = size.height+40;
            }
        }
        levelTotal.position = ccp(levelTotal_x,levelTotal_y);
        levelTotal.color = ccc3(255,255,255);
        [bg addChild:levelTotal z:10];
        
        CCMenuItemImage * playAgain = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithFile:@"playAgainN.png"] selectedSprite:[CCSprite spriteWithFile:@"playAgainH.png"] target:self selector:@selector(btnTouch:)];
        playAgain.tag = 1;
        playAgain.position = ccp(0,0);
        playAgain.normalImage.position = ccp(0, 0);
        playAgain.selectedImage.position = ccp(playAgain.normalImage.position.x, playAgain.normalImage.position.y);
        
        CCMenuItemImage * shared = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithFile:@"sharedN.png"] selectedSprite:[CCSprite spriteWithFile:@"sharedH.png"] target:self selector:@selector(btnTouch:)];
        shared.tag = 2;
        shared.position = ccp(playAgain.position.x,playAgain.position.y-playAgain.contentSize.height-10);
        shared.normalImage.position = ccp(0, 0);
        shared.selectedImage.position = ccp(shared.normalImage.position.x, shared.normalImage.position.y);
        
        CCMenu * menu = [CCMenu menuWithItems:playAgain,shared, nil];
        menu.anchorPoint = CGPointMake(0.5, 0.5);
        if (IS_OS_7_OR_LATER) {
            playAgain_x = size.width/2+((size.width/2)/2);
            playAgain_y = (size.height/2)-20;
        }else{
            if ([self isRetina]) {
                playAgain_x = size.width/2+((size.width/2)/2);
                playAgain_y = (size.height/2)-20;
            }else{
                playAgain_x = size.width+((size.width/2)/2);
                playAgain_y = size.height;
            }
        }
        menu.position = ccp(playAgain_x,playAgain_y);
        [bg addChild:menu z:30];
        
        

    [self scheduleUpdate];
}
-(void)btnTouch:(id)sender
{
    CCMenu * tmp = (CCMenu*)sender;
    switch (tmp.tag) {
        case 1:
        {
            CCScene * menu = [menuScene scene];
            CCTransitionMoveInR * t = [CCTransitionMoveInR transitionWithDuration:0.5 scene:menu];
            [[CCDirector sharedDirector] replaceScene:t];
        }
            break;
        case 2:
        {
            [self createLoading];
            UIImage * img = [self renderUIImageFromSprite:bg];
//            UIImage * img = [UIImage imageNamed:@"sharedN.png"];
            AppController * app = (AppController *)[[UIApplication sharedApplication] delegate];
            [app postScoreToFaceBook:img];
        }
            break;
    }
}
-(void)createLoading
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSpriteFrameCache * frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableArray * actorFrames = [NSMutableArray array];
    for (int i = 2; i<73; i++) {
        [actorFrames addObject:[frameCache spriteFrameByName:[NSString stringWithFormat:@"loading%d.png",i]]];
    }
    CCAnimation * runAnima = [CCAnimation
                              animationWithSpriteFrames:actorFrames delay:0.1f];
    CCSprite * loading = [CCSprite spriteWithSpriteFrameName:@"loading1.png"];
    loading.anchorPoint = CGPointMake(0.5, 0.5);
    loading.tag = 456;
    loading.position = ccp(size.width/2, size.height/2);
    [self addChild:loading z:99];

    
    CCAction * actorAction = [CCRepeatForever actionWithAction:
                              [CCAnimate actionWithAnimation:runAnima]];

    [loading runAction:actorAction];
}
- (UIImage*) renderUIImageFromSprite:(CCSprite*)sprite
{
    
    int tx = sprite.contentSize.width;
    int ty = sprite.contentSize.height;
    
    CCRenderTexture *renderer    = [CCRenderTexture renderTextureWithWidth:tx height:ty];
    
//    sprite.anchorPoint  = CGPointZero;
    
    [renderer begin];
    [sprite visit];
    [renderer end];
    
    return [renderer getUIImageFromBuffer];
}
-(void)update:(ccTime)delta
{
    AppController * app = (AppController *)[[UIApplication sharedApplication] delegate];
    NSLog(@"[app getPostScoreStage] %@",[app getPostScoreStage]);
    if ([[app getPostScoreStage] isEqualToString:@"FINISH"]) {
        [self removeChildByTag:456 cleanup:YES];
    }
}
@end
