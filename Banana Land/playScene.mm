//
//  playScene.m
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 4/15/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import "playScene.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "gameOverScene.h"
#import "menuScene.h"
#define kSampleAdUnitID @"e1340c6beb484713"
#define ARC4RANDOM_MAX 0x100000000
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@implementation playScene
@synthesize interstitial_;
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	playScene *layer = [playScene node];
	[scene addChild: layer];
	return scene;
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"Received ad successfully");
    AppController * app = (AppController*)[[UIApplication sharedApplication]delegate];
    [interstitial_ presentFromRootViewController:[app navController]];
}
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}
-(void)createBanner
{
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = kSampleAdUnitID;
    interstitial_.delegate = self;
    GADRequest * req = [GADRequest request];
    req.testDevices = @[
                        @"7df5543867e52e34c8ddaa52122808846b89894c",
                        ];
    [interstitial_ loadRequest:req];
}

-(id) init
{
	if( (self=[super init])) {

        itemsNum = 1;
        enemyNum = 1;
        bulletSpeed = 0.7;
        scrollSpeed = 10;
        coinsScore = 1000;
        bananaScore = 500;
        hotdogScore = 150;
        guitarScore = 2000;
        moneyScore = 200;
        totalScore = 0;
        enemyScore = 100;
        level = 0;
        jumpSpeed = 3;
        itemTimmer = 10;
//        enemyScore = enemyScore*100;
        itemsSpecialStage = [[NSMutableString alloc] initWithString:@"NORMAL"];
        
        coinsArray = [[NSMutableArray alloc] init];
        enemyArray = [[NSMutableArray alloc] init];
        bulletArray = [[NSMutableArray alloc] init];
        heartArray = [[NSMutableArray alloc] init];
        
        CCSpriteFrameCache * frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];        
        [frameCache addSpriteFramesWithFile:@"ac11.plist"];
        [frameCache addSpriteFramesWithFile:@"pause.plist"];
        CCSpriteBatchNode *spriteSheet2 = [CCSpriteBatchNode batchNodeWithFile:@"ac11.png"];
		[self addChild:spriteSheet2];
        
        AppController * app = (AppController *)[[UIApplication sharedApplication] delegate];
        NSDictionary * userDefault = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        playerName = [userDefault objectForKey:@"bananaland_session_playerSelected"];

        if (![[app getmusicPlayerSelected] isEqualToString:@""]) {
            [[SimpleAudioEngine sharedEngine]preloadBackgroundMusic:[app getmusicPlayerSelected]];
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5];
            [[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0];
        }
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"coins.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"037.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"banana.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"durain.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"guitar.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"heart.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hotdog.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"john.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"money.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"shit.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"boom.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"die.mp3"];
        
		CGSize  size = [[CCDirector sharedDirector] winSize];
        int r = [self getRandomNumberBetweenMin:1 andMax:2];
        switch (r) {
            case 1:
            {
                if(IS_IPHONE5){
                    CCSprite * bg = [CCSprite spriteWithFile:@"bg2.png"];
                    bg.anchorPoint = CGPointMake(0.5, 0.5);
                    bg.position = ccp(size.width/2, size.height/2);
                    [self addChild:bg z:0];
                }else{
                    CCSprite * bg = [CCSprite spriteWithFile:@"bg2-iphone4.png"];
                    bg.anchorPoint = CGPointMake(0.5, 0.5);
                    bg.position = ccp(size.width/2, size.height/2);
                    [self addChild:bg z:0];
                }
            }
                break;
            case 2:
            {
                if (IS_IPHONE5) {
                    CCSprite * bg = [CCSprite spriteWithFile:@"bgMenuScene.png"];
                    bg.anchorPoint = CGPointMake(0.5, 0.5);
                    bg.position = ccp(size.width/2, size.height/2);
                    [self addChild:bg z:0];
                    [self createCloud];
                }else{
                    CCSprite * bg = [CCSprite spriteWithFile:@"bgMenuScene-iphone4.png"];
                    bg.anchorPoint = CGPointMake(0.5, 0.5);
                    bg.position = ccp(size.width/2, size.height/2);
                    [self addChild:bg z:0];
                    [self createCloud];
                }
            }
                break;
            default:
                break;
        }
        
        human = [[charector alloc] init];
        [human setActorDisplay:playerName];
        [human move:ccp(size.width/2,120)];
        
        [self addChild:human z:20];
        [human changeState:[NSMutableString stringWithString:@"ALIVE"]];
        [self setAccelerometerEnabled:YES];        
	}
	
	return self;
}
-(void)onEnter
{
    [super onEnter];
//    [self createBanner];
    [[[CCDirector sharedDirector] touchDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:NO];
    AppController * app = (AppController *)[[UIApplication sharedApplication] delegate];
    if (![[app getmusicPlayerSelected] isEqualToString:@""]) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[app getmusicPlayerSelected]];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:3.0];
    }
    CGSize size = [[CCDirector sharedDirector] winSize];
    scoreLabel = [CCLabelTTF labelWithString:@"0 คะแนน" fontName:@"SP Aftershock" fontSize:26];
    scoreLabel.anchorPoint  = CGPointMake(0, 0);
    scoreLabel.position = ccp((size.width/2)-(scoreLabel.contentSize.width/2),size.height-30);
    scoreLabel.color = ccc3(0,0,0);
    [self addChild:scoreLabel z:10];
    
    CCMenuItemImage * pauseBtn = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pauseN.png"] selectedSprite:[CCSprite spriteWithFile:@"pauseH.png"] target:self selector:@selector(pauseTouch:)];
    pauseBtn.tag = 4;
    pauseBtn.position = ccp(0,0);
    pauseBtn.normalImage.position = ccp(0, 0);
    pauseBtn.selectedImage.position = ccp(pauseBtn.normalImage.position.x, pauseBtn.normalImage.position.y);
    
    CCMenu * menu = [CCMenu menuWithItems:pauseBtn, nil];
    menu.anchorPoint = CGPointMake(0.5, 0.5);
    menu.position = ccp(size.width-pauseBtn.contentSize.width-10, size.height-pauseBtn.contentSize.height);
    [self addChild:menu z:3];
    
    [self setUpHeart:4];
    [self scheduleUpdate];
    [self schedule:@selector(randomItems) interval:itemTimmer];
    [self setUpPowerBar];
}
-(void)pauseTouch:(id)sender
{

    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite * bg = [CCSprite spriteWithSpriteFrameName:@"pauseBg.png"];
    bg.tag = 321;
    bg.anchorPoint = CGPointMake(0.5, 0.5);
    bg.position = ccp(size.width/2, size.height/2);
    [self addChild:bg z:100];
   
    CCMenuItemImage * mainMenu = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"mainMenuN.png"] selectedSprite:[CCSprite spriteWithFile:@"mainMenuH.png"] target:self selector:@selector(pauseActionTouch:)];
    mainMenu.tag = 1;
    mainMenu.position = ccp(0,0);
    mainMenu.normalImage.position = ccp(0, 0);
    mainMenu.selectedImage.position = ccp(mainMenu.normalImage.position.x, mainMenu.normalImage.position.y);

    CCMenuItemImage * resume = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"resumeN.png"] selectedSprite:[CCSprite spriteWithFile:@"resumeN.png"] target:self selector:@selector(pauseActionTouch:)];
    resume.tag = 2;
    resume.position = ccp(mainMenu.position.x,mainMenu.position.y-mainMenu.contentSize.height-5);
    resume.normalImage.position = ccp(0, 0);
    resume.selectedImage.position = ccp(resume.normalImage.position.x, resume.normalImage.position.y);
    
    CCMenuItemImage * soundUp = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"upN.png"] selectedSprite:[CCSprite spriteWithFile:@"upH.png"] target:self selector:@selector(pauseActionTouch:)];
    soundUp.tag = 3;
    soundUp.position = ccp(resume.position.x+50,resume.position.y-resume.contentSize.height-13);
    soundUp.normalImage.position = ccp(0, 0);
    soundUp.selectedImage.position = ccp(soundUp.normalImage.position.x, soundUp.normalImage.position.y);

    CCMenuItemImage * soundDown = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"delN.png"] selectedSprite:[CCSprite spriteWithFile:@"delH.png"] target:self selector:@selector(pauseActionTouch:)];
    soundDown.tag = 4;
    soundDown.position = ccp(resume.position.x,resume.position.y-resume.contentSize.height-13);
    soundDown.normalImage.position = ccp(0, 0);
    soundDown.selectedImage.position = ccp(soundDown.normalImage.position.x, soundDown.normalImage.position.y);
    
    CCMenuItemImage * effectUp = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"upN.png"] selectedSprite:[CCSprite spriteWithFile:@"upH.png"] target:self selector:@selector(pauseActionTouch:)];
    effectUp.tag = 5;
    effectUp.position = ccp(resume.position.x+50,resume.position.y-resume.contentSize.height-60);
    effectUp.normalImage.position = ccp(0, 0);
    effectUp.selectedImage.position = ccp(effectUp.normalImage.position.x, effectUp.normalImage.position.y);
    
    CCMenuItemImage * effectDown = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"delN.png"] selectedSprite:[CCSprite spriteWithFile:@"delH.png"] target:self selector:@selector(pauseActionTouch:)];
    effectDown.tag = 6;
    effectDown.position = ccp(resume.position.x,resume.position.y-resume.contentSize.height-60);
    effectDown.normalImage.position = ccp(0, 0);
    effectDown.selectedImage.position = ccp(effectDown.normalImage.position.x, effectDown.normalImage.position.y);
    
    CCMenu * menu = [CCMenu menuWithItems:mainMenu,resume,soundUp,soundDown,effectUp,effectDown, nil];
    menu.anchorPoint = CGPointMake(0.5, 0.5);
    menu.position = ccp(bg.contentSize.width/2,bg.contentSize.height-mainMenu.contentSize.height);
    [bg addChild:menu z:1];
    
    CCSprite * sound = [CCSprite spriteWithSpriteFrameName:@"music.png"];
    sound.anchorPoint = CGPointMake(0.5, 0.5);
    sound.position = ccp((bg.contentSize.width/2)-(resume.contentSize.width/2), (bg.contentSize.height/2)-20);
    [bg addChild:sound z:2];
    
    CCSprite * effect = [CCSprite spriteWithSpriteFrameName:@"effect.png"];
    effect.anchorPoint = CGPointMake(0.5, 0.5);
    effect.position = ccp((bg.contentSize.width/2)-(resume.contentSize.width/2), (bg.contentSize.height/2)-60);
    [bg addChild:effect z:2];
    
    [self pauseSchedulerAndActions];
    for (CCNode *child in [self children]) {
        [child pauseSchedulerAndActions];
        
    }
}
-(void)pauseActionTouch:(id)sender
{
    CCMenu * tmp = (CCMenu*)sender;
    switch (tmp.tag) {
        case 1:
        {
            CCScene * menuSceneObj = [menuScene scene];
            CCTransitionMoveInR * t = [CCTransitionMoveInR transitionWithDuration:0.5 scene:menuSceneObj];
            [[CCDirector sharedDirector] replaceScene:t];
        }
            break;
        case 2:
        {
            [self removeChildByTag:321 cleanup:YES];
            [self resumeSchedulerAndActions];
            for (CCNode *child in [self children]) {
                [child resumeSchedulerAndActions];
                
            }
        }
            break;
        case 3:
        {
            NSLog(@"%f",[[SimpleAudioEngine sharedEngine] backgroundMusicVolume]);
            if ([[SimpleAudioEngine sharedEngine] backgroundMusicVolume] < 10.0) {
                float svol = [[SimpleAudioEngine sharedEngine] backgroundMusicVolume];
                svol += 1;
                [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:svol];
            }
        }
            break;
        case 4:
        {
            NSLog(@"%f",[[SimpleAudioEngine sharedEngine] backgroundMusicVolume]);
            if ([[SimpleAudioEngine sharedEngine] backgroundMusicVolume] > 0.0) {
                float svol = [[SimpleAudioEngine sharedEngine] backgroundMusicVolume];
                svol -= 1;
                [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:svol];
            }
        }
            break;
        case 5:
        {
            NSLog(@"%f",[[SimpleAudioEngine sharedEngine] effectsVolume]);
            if ([[SimpleAudioEngine sharedEngine] effectsVolume] < 10.0) {
                float evol = [[SimpleAudioEngine sharedEngine] effectsVolume];
                evol += 1;
                [[SimpleAudioEngine sharedEngine] setEffectsVolume:evol];
            }
            [[SimpleAudioEngine sharedEngine] playEffect:@"shoot.mp3"];
        }
            break;
        case 6:
        {
            NSLog(@"%f",[[SimpleAudioEngine sharedEngine] effectsVolume]);
            if ([[SimpleAudioEngine sharedEngine] effectsVolume] > 0.0) {
                float evol = [[SimpleAudioEngine sharedEngine] effectsVolume];
                evol -= 1;
                [[SimpleAudioEngine sharedEngine] setEffectsVolume:evol];
            }
            [[SimpleAudioEngine sharedEngine] playEffect:@"shoot.mp3"];
        }
            break;
        default:
            break;
    }
}
-(void)powerBarUp
{
    if (healthBar.percentage < 100) {
        float healthBarFrom = healthBar.percentage;
        healthBar.percentage += 2.0;
        [healthBar runAction:[CCProgressFromTo actionWithDuration:0.5f from:healthBarFrom to:healthBar.percentage]];
    }
}
-(void)powerBarDown
{
    NSLog(@"%f",healthBar.percentage);
    if(healthBar.percentage > 0)
    {
        float healthBarFrom = healthBar.percentage;
        healthBar.percentage -= 10.0;
        [healthBar runAction:[CCProgressFromTo actionWithDuration:0.5f from:healthBarFrom to:healthBar.percentage]];
    }else{
        [human changeState:[NSMutableString stringWithString:@"DEATH"]];
    }
}
-(void)setUpPowerBar
{
    CCSprite *movableSprite = [CCSprite spriteWithFile:@"healthbar.png"];
    healthBar = [CCProgressTimer progressWithSprite:movableSprite];
    healthBar.type = kCCProgressTimerTypeBar;
    healthBar.midpoint = ccp(0,0.5);
    healthBar.anchorPoint = CGPointMake(0, 0.5);
    healthBar.barChangeRate = ccp(1, 0);
    [healthBar runAction:[CCProgressFromTo actionWithDuration:2.0f from:0.0f to:100.0f]];
    healthBar.position = ccp(0, healthBar.contentSize.height/2);
    [self addChild:healthBar];
}
-(void)setUpHeart:(int)n
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    powerLabel = [CCLabelTTF labelWithString:@"พลังชีวิต" fontName:@"SP Aftershock" fontSize:26];
    powerLabel.anchorPoint  = CGPointMake(0, 0);
    powerLabel.position = ccp(20,size.height-30);
    powerLabel.color = ccc3(0,0,0);
    [self addChild:powerLabel z:10];

    float x = powerLabel.position.x+powerLabel.contentSize.width+10;
    for (int i = 0; i<n; i++) {
        CCSprite * heart = [CCSprite spriteWithFile:@"hearPower.png"];
        heart.anchorPoint = CGPointMake(0.5, 0.5);
        heart.position = ccp(x, size.height-15);
        x = heart.position.x+heart.contentSize.width+5;
        [heartArray addObject:heart];
        [self addChild:heart z:10];
        
    }
}
-(void)levelUp
{
    float levelUp = floor(totalScore/10000);
    if (levelUp > level) {
        level = levelUp;
        
        switch (level) {
            case 0:
            {
                jumpSpeed = 3;
                enemyNum = 1;
            }
                break;
            case 1:
            {
                jumpSpeed = 3;
                enemyNum = 2;
            }
                break;
            case 2:
            {
                jumpSpeed = 3;
                enemyNum = 3;
                [self unschedule:@selector(randomItems)];
                itemTimmer = 15.0;
                [self schedule:@selector(randomItems) interval:itemTimmer];
            }
                break;
            case 3:
            {
                jumpSpeed = 3;
                enemyNum = 3;
                [self unschedule:@selector(randomItems)];
                itemTimmer = 20.0;
                [self schedule:@selector(randomItems) interval:itemTimmer];
            }
                break;
            case 4:
            {
                jumpSpeed = 3;
                enemyNum = 4;
                [self unschedule:@selector(randomItems)];
                itemTimmer = 25.0;
                [self schedule:@selector(randomItems) interval:itemTimmer];
            }
                break;
            default:
            {
                jumpSpeed = 2.8;
                enemyNum = 4;
                [self unschedule:@selector(randomItems)];
                itemTimmer = 30.0;
                [self schedule:@selector(randomItems) interval:itemTimmer];
            }
                break;
        }

        CGSize size = [CCDirector sharedDirector].winSize;
        levelUpText = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level %d",level] fontName:@"SP Aftershock" fontSize:46];
        levelUpText.anchorPoint  = CGPointMake(0.5, 0.5);
        levelUpText.position = ccp(size.width/2,size.height/2);
        levelUpText.tag = 686;
        levelUpText.color = ccc3(0,0,0);
        [self addChild:levelUpText z:10];
        CCDelayTime *interval = [CCDelayTime actionWithDuration:0.3];
        CCSequence * levelUpAction = [CCSequence actions:
                                      [CCFadeIn actionWithDuration:2.0],
                                      interval,
                                      [CCFadeOutDownTiles actionWithDuration:0.3],
                                      [CCCallFunc actionWithTarget:self selector:@selector(levelUpActionFinish)],
                                      nil];
        [levelUpText runAction:levelUpAction];
        
        CCParticleExplosion * ouk = [[CCParticleExplosion alloc] initWithTotalParticles:50];
        ouk.speed= 100;
        ouk.duration = 0.5;
        ouk.life = 1.6;
        ouk.texture = [[CCTextureCache sharedTextureCache] addImage:@"star.png"];
        ouk.blendAdditive = NO;
        ouk.autoRemoveOnFinish = YES;
        
        ccColor4F startColor, startColorVar, endColor, endColorVar;
        startColor.r = 1.0f;
        startColor.g = 1.0f;
        startColor.b = 1.0f;
        startColor.a = 1.0f;
        
        startColorVar.r = 0.0f;
        startColorVar.g = 0.0f;
        startColorVar.b = 0.0f;
        startColorVar.a = 0.0f;
        
        endColor.r = 1.0f;
        endColor.g = 1.0f;
        endColor.b = 1.0f;
        endColor.a = 1.0f;
        
        endColorVar.r = 0.0f;
        endColorVar.g = 0.0f;
        endColorVar.b = 0.0f;
        endColorVar.a = 0.0f;
        
        ouk.startColor = startColor;
        ouk.startColorVar = startColorVar;
        ouk.endColor = endColor;
        ouk.endColorVar = endColorVar;
        
        
        ouk.position = ccp(size.width/2,size.height/2);
        [self addChild:ouk z:9];
    }
}
-(void)levelUpActionFinish
{
    [self removeChildByTag:686 cleanup:YES];
}
-(void)updateHeart:(int)n
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    if ([heartArray count]> 0 && [heartArray count]<4) {
        CCSprite * lastHeart = [heartArray lastObject];
        
        float x = lastHeart.position.x+lastHeart.contentSize.width+5;
        for (int i = 0; i<n; i++) {
            CCSprite * heart = [CCSprite spriteWithFile:@"hearPower.png"];
            heart.anchorPoint = CGPointMake(0.5, 0.5);
            heart.position = ccp(x, size.height-15);
            x = heart.position.x+heart.contentSize.width+5;
            [heartArray addObject:heart];
            [self addChild:heart z:10];
        }
    }else{
        float x = powerLabel.position.x+powerLabel.contentSize.width+10;
        for (int i = 0; i<n; i++) {
            CCSprite * heart = [CCSprite spriteWithFile:@"hearPower.png"];
            heart.anchorPoint = CGPointMake(0.5, 0.5);
            heart.position = ccp(x, size.height-15);
            x = heart.position.x+heart.contentSize.width+5;
//            [heartArray addObject:heart];
            [self addChild:heart z:10];
            
        }
    }
}
-(void)removeHeart
{
    if([heartArray count]>1){
        NSMutableArray * unUsedHeart = [[NSMutableArray alloc] init];
        CCSprite * lastedHeart = [heartArray lastObject];
        [unUsedHeart addObject:lastedHeart];
        [self removeChild:lastedHeart cleanup:YES];
        [heartArray removeObjectsInArray:unUsedHeart];
    }else{
        NSMutableArray * unUsedHeart = [[NSMutableArray alloc] init];
        CCSprite * lastedHeart = [heartArray lastObject];
        [unUsedHeart addObject:lastedHeart];
        [self removeChild:lastedHeart cleanup:YES];
        [heartArray removeObjectsInArray:unUsedHeart];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"die.mp3"];
        [human changeState:[NSMutableString stringWithString:@"DEATH"]];
    }
}
-(void)createCloud
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite * c1 = [CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
    c1.anchorPoint = CGPointMake(0, 1);
    c1.position = ccp(10, size.height-20);
    CCSequence * s1 = [CCSequence actions:
                       [CCMoveTo actionWithDuration:10.0 position:ccp(c1.position.x+50, size.height-20)],
                       [CCMoveTo actionWithDuration:10.0 position:ccp(c1.position.x-50, size.height-20)],
                       nil];
    [c1 runAction:[CCRepeatForever actionWithAction:s1]];
    [self addChild:c1 z:1];
    
    CCSprite * c2 = [CCSprite spriteWithSpriteFrameName:@"cloud2.png"];
    c2.anchorPoint = CGPointMake(0, 1);
    c2.position = ccp(80, size.height-40);
    CCSequence * s2 = [CCSequence actions:
                       [CCMoveTo actionWithDuration:10.0 position:ccp(c2.position.x-30, size.height-40)],
                       [CCMoveTo actionWithDuration:10.0 position:ccp(c2.position.x+30, size.height-40)],
                       nil];
    [c2 runAction:[CCRepeatForever actionWithAction:s2]];
    [self addChild:c2 z:1];
    
    CCSprite * c3 = [CCSprite spriteWithSpriteFrameName:@"cloud3.png"];
    c3.anchorPoint = CGPointMake(0, 1);
    c3.position = ccp(250, size.height-20);
    CCSequence * s3 = [CCSequence actions:
                       [CCMoveTo actionWithDuration:10.0 position:ccp(c3.position.x-50, size.height-20)],
                       [CCMoveTo actionWithDuration:10.0 position:ccp(c3.position.x+50, size.height-20)],
                       nil];
    [c3 runAction:[CCRepeatForever actionWithAction:s3]];
    [self addChild:c3 z:1];
    
    CCSprite * c4 = [CCSprite spriteWithSpriteFrameName:@"cloud4.png"];
    c4.anchorPoint = CGPointMake(0, 1);
    c4.position = ccp(450, size.height-30);
    CCSequence * s4 = [CCSequence actions:
                       [CCMoveTo actionWithDuration:10.0 position:ccp(c4.position.x-20, size.height-30)],
                       [CCMoveTo actionWithDuration:10.0 position:ccp(c4.position.x+20, size.height-30)],
                       nil];
    [c4 runAction:[CCRepeatForever actionWithAction:s4]];
    [self addChild:c4 z:1];
    
    CCSprite * c5 = [CCSprite spriteWithSpriteFrameName:@"cloud5.png"];
    c5.anchorPoint = CGPointMake(0, 1);
    c5.position = ccp(400, size.height-20);
    CCSequence * s5 = [CCSequence actions:
                       [CCMoveTo actionWithDuration:10.0 position:ccp(c5.position.x+20, size.height-20)],
                       [CCMoveTo actionWithDuration:10.0 position:ccp(c5.position.x-20, size.height-20)],
                       nil];
    [c5 runAction:[CCRepeatForever actionWithAction:s5]];
    [self addChild:c5 z:1];
    
    CCSprite * c6 = [CCSprite spriteWithSpriteFrameName:@"cloud6.png"];
    c6.anchorPoint = CGPointMake(0, 1);
    c6.position = ccp(490, size.height-20);
    CCSequence * s6 = [CCSequence actions:
                       [CCMoveTo actionWithDuration:10.0 position:ccp(c5.position.x+20, size.height-20)],
                       [CCMoveTo actionWithDuration:10.0 position:ccp(c5.position.x-20, size.height-20)],
                       nil];
    [c6 runAction:[CCRepeatForever actionWithAction:s6]];
    [self addChild:c6 z:1];
}
-(int) getRandomNumberBetweenMin:(int)min andMax:(int)max
{
    return ( (arc4random() % (max-min+1)) + min );
}
-(void)removeBOOM
{
    [self removeChildByTag:1009 cleanup:YES];
}
-(void)genStarExplode:(CGPoint)pos
{

    CCSpriteFrameCache * frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableArray * actorFrames = [NSMutableArray array];
    for (int i = 2; i<16; i++) {
        [actorFrames addObject:[frameCache spriteFrameByName:[NSString stringWithFormat:@"Boom_Animate_%02d.png",i]]];
    }
    CCAnimation * runAnima = [CCAnimation
                              animationWithSpriteFrames:actorFrames delay:0.05f];
    CCSprite * boom = [CCSprite spriteWithSpriteFrameName:@"Boom_Animate_01.png"];
    boom.anchorPoint = CGPointMake(0.5, 0.5);
    boom.position = pos;
    [self addChild:boom z:99];
    boom.tag = 1009;
    CCSequence * seq = [CCSequence actions:[CCAnimate actionWithAnimation:runAnima],
                        [CCCallFunc actionWithTarget:self selector:@selector(removeBOOM)],
                        nil];
    [boom runAction:seq];
    [[SimpleAudioEngine sharedEngine] playEffect:@"boom.mp3"];
}
-(void)bombEffect:(CGPoint)pos
{
    CCParticleExplosion * ouk = [[CCParticleExplosion alloc] initWithTotalParticles:50];
    ouk.speed= 100;
    ouk.duration = 0.5;
    ouk.life = 1.6;
    ouk.blendAdditive = YES;
    ouk.autoRemoveOnFinish = YES;
    ouk.position = ccp(pos.x,pos.y);
    [self addChild:ouk z:3];
}
- (void) randomItems
{
    if([coinsArray count] < itemsNum){
        coins = [[gameItem alloc] init];
        if ([itemsSpecialStage isEqualToString:@"JOHN"]) {
            [coins randomItems:[self getRandomNumberBetweenMin:1 andMax:6]];
        }else{
            [coins randomItems:[self getRandomNumberBetweenMin:1 andMax:7]];
        }
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        int xPos = arc4random() % (int) screenSize.width+20;
        int yPos = arc4random() % (int) screenSize.height;
        float px = 0;
        
        if (yPos>screenSize.height) {
            yPos = screenSize.height;
        }
        if (xPos < 50) {
            xPos = 90;
        }
        if (xPos >= screenSize.width-90) {
            xPos = screenSize.width-90;
        }
        
        if (xPos > screenSize.width/2) {
            px = -50;
        }else{
            px = screenSize.width+50;
        }
        [coins move:ccp(px ,1)];
        [coins runAction:[CCJumpTo actionWithDuration:jumpSpeed position:ccp(xPos, -10) height:screenSize.height-coins.contentSize.height jumps:1]];
        
        
        [self addChild:coins z:11];
        [coinsArray addObject:coins];
        [coins release];
    }
}
- (void) randomEnemy
{
    if([enemyArray count] < enemyNum){
        enemy = [[gameItem alloc] init];
        
        [enemy randomItems:[self getRandomNumberBetweenMin:8 andMax:11]];
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        int xPos = arc4random() % (int) screenSize.width+20;
        int yPos = arc4random() % (int) screenSize.height;
        
        float px = 0;
        
        if (yPos>screenSize.height) {
            yPos = screenSize.height;
        }
        if (xPos < 50) {
            xPos = 90;
        }
        if (xPos >= screenSize.width-90) {
            xPos = screenSize.width-90;
        }
        
        if (xPos > screenSize.width/2) {
            px = -50;
        }else{
            px = screenSize.width+50;
        }
        [enemy move:ccp(px,1)];
        [enemy runAction:[CCJumpTo actionWithDuration:jumpSpeed position:ccp(xPos, -10) height:screenSize.height-enemy.contentSize.height jumps:1]];
        
        
        [self addChild:enemy z:11];
        [enemyArray addObject:enemy];
        [enemy release];
    }
}
-(void)scoreEffect:(CGPoint)pos andScore:(int)m_score
{
    //////////////// add score effect//////////////
    CCLabelTTF * s = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%d",m_score] fontName:@"SP Aftershock" fontSize:38];
    s.anchorPoint  = CGPointMake(0, 0);
    s.tag = 999;
    s.color = ccc3(255,0,0);
    s.position = ccp(pos.x,pos.y);
    [self addChild:s z:10];
    
    CCSequence * addScoreAction = [CCSequence actions:
                                   [CCMoveTo actionWithDuration:0.3 position:ccp(s.position.x, s.position.y+20)],
                                   [CCCallFunc actionWithTarget:self selector:@selector(changeAddScoreFinish)],
                                   nil];
    [s runAction:addScoreAction];
}
-(void)updateScore
{
    
    int t = totalScore;
    
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:t]];
    
    [scoreLabel setString:[NSString stringWithFormat:@"%@ คะแนน",formatted]];
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    scoreLabel.position = ccp((screenSize.width/2)-(scoreLabel.contentSize.width/2), screenSize.height-30);
    [formatter release];
    
}
-(void)changeAddScoreFinish
{
    [self removeChildByTag:999 cleanup:YES];
}
-(void)changeJohnOffEffect
{
    itemsNum = 1 * level;
    if (itemsNum == 0) {
        itemsNum = 1;
    }
    [itemsSpecialStage setString:@"NORMAL"];
}
-(void)collisionEnemys
{
    BOOL isHitPlayer = NO;
    NSMutableArray * unUseItems = [NSMutableArray array];
    for (gameItem * itemTmp in enemyArray) {
        CGPoint newPoint = itemTmp.position;
        if(newPoint.y > 0){
            CGRect eBox = [itemTmp itemBoundingBox];
            CGRect pBox = [human actorBoundingBox];
            
            isHitPlayer = CGRectIntersectsRect(pBox, eBox);
            if (isHitPlayer && [[human state] isEqualToString:@"ALIVE"]) {
                [unUseItems addObject:itemTmp];
                [self removeChild:itemTmp cleanup:YES];
                [self removeHeart];
                
                
                switch ([itemTmp getItemType]) {
                    case 8:
                    {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"durain.mp3"];
                    }
                        break;
                    case 9:
                    {

                    }
                        break;
                    case 10:
                    {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"037.mp3"];
                    }
                        break;
                    case 11:
                    {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"shit.wav"];
                    }
                        break;
                }
                [self genStarExplode:human.position];
                [self runAction:[CCShake actionWithDuration:1.0f amplitude:ccp(5,5) dampening:false]];                
            }

        }else{
            [self genStarExplode:ccp(itemTmp.position.x, 0)];
            [unUseItems addObject:itemTmp];
            [self removeChild:itemTmp cleanup:YES];
            [self powerBarDown];
        }
        
    }
    if([unUseItems count] > 0){
        [enemyArray removeObjectsInArray:unUseItems];
    }
}
-(void)collisionBullet:(ccTime)delta
{
    BOOL isHitPlayer = NO;
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    NSMutableArray * unUseItems = [NSMutableArray array];
    NSMutableArray * unUseEnemy = [NSMutableArray array];
    for (CCSprite * bullet in bulletArray) {
        
        
        CGPoint newPoint = bullet.position;
        NSNumber* factor = [NSNumber numberWithFloat:bulletSpeed];
        newPoint.y += (scrollSpeed * factor.floatValue) * (delta * 50);
        
        if(newPoint.y < screenSize.height){
            
            bullet.position = newPoint;
            for (gameItem * enemyItems in enemyArray) {
                if (enemyItems.position.y > 0) {
                    CGRect eBox = [enemyItems itemBoundingBox];
                    CGSize s  = bullet.contentSize;
                    s.width  = (s.width*(bullet.scaleX/2));
                    s.height = (s.height*(bullet.scaleY/2));

                    CGRect bulletBox = CGRectMake(
                                                bullet.position.x-(s.width/2),
                                                bullet.position.y + 1,
                                                s.width,
                                                s.height);
                    isHitPlayer = CGRectIntersectsRect(eBox, bulletBox);
                    if (isHitPlayer && [[human state] isEqualToString:@"ALIVE"]) {
                        totalScore += enemyScore;
                        [self scoreEffect:ccp(enemyItems.position.x, enemyItems.position.y-100) andScore:enemyScore];
                        [self levelUp];
                        [self genStarExplode:bullet.position];
                        [unUseItems addObject:bullet];
                        [self removeChild:bullet cleanup:YES];
                        [unUseEnemy addObject:enemyItems];
                        [self removeChild:enemyItems cleanup:YES];
                        [self powerBarUp];
                    }
                }
            }
            
        }else{
            [unUseItems addObject:bullet];
            [self removeChild:bullet cleanup:YES];
        }
        
    }
    if([unUseItems count] > 0){
        [bulletArray removeObjectsInArray:unUseItems];
    }
    if ([unUseEnemy count] > 0) {
        [enemyArray removeObjectsInArray:unUseEnemy];
    }
}
-(void)collisionItems
{
    BOOL isHitPlayer = NO;
//    CGSize screenSize = [CCDirector sharedDirector].winSize;
    NSMutableArray * unUseItems = [NSMutableArray array];
    for (gameItem * itemTmp in coinsArray) {
        CGPoint newPoint = itemTmp.position;
        if(newPoint.y > 0){
            CGRect eBox = [itemTmp itemBoundingBox];
            CGRect pBox = [human actorBoundingBox];
            
            isHitPlayer = CGRectIntersectsRect(pBox, eBox);
            if (isHitPlayer && [[human state] isEqualToString:@"ALIVE"]) {
                [unUseItems addObject:itemTmp];
                [self removeChild:itemTmp cleanup:YES];
                
                switch ([itemTmp getItemType]) {
                    case 1:
                    {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"coins.wav"];
                        [self scoreEffect:human.position andScore:coinsScore];
                        totalScore += coinsScore;
                    }
                        break;
                    case 2:
                    {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"banana.mp3"];
                        [self scoreEffect:human.position andScore:bananaScore];
                        totalScore += bananaScore;
                    }
                        break;
                    case 3:
                    {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"guitar.mp3"];
                        [self scoreEffect:human.position andScore:guitarScore];
                        totalScore += guitarScore;
                    }
                        break;
                    case 4:
                    {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"heart.mp3"];
                        [self updateHeart:1];
                    }
                    case 5:
                    {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"hotdog.mp3"];
                        [self scoreEffect:human.position andScore:hotdogScore];
                        totalScore += hotdogScore;
                    }
                        break;
                    case 6:
                    {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"money.mp3"];
                        [self scoreEffect:human.position andScore:moneyScore];
                        totalScore += moneyScore;
                    }
                        break;
                    case 7:
                    {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"john.mp3"];
                        itemsNum = 5 * level;
                        if (itemsNum == 0) {
                            itemsNum = 5;
                        }
                        [self scheduleOnce:@selector(changeJohnOffEffect) delay:5.0];
                        [itemsSpecialStage setString:@"JOHN"];
                    }
                        break;
                }
                [self levelUp];
            }
        }else{
            [unUseItems addObject:itemTmp];
            [self removeChild:itemTmp cleanup:YES];
        }
        
    }
    if([unUseItems count] > 0){
        [coinsArray removeObjectsInArray:unUseItems];
    }
}
-(void)update:(ccTime)delta
{
    [self updatePlayerAcc];
    [self controlCharector:delta];
    [self updateScore];

    if ([[human state] isEqualToString:@"DEATH"] || [[human state] isEqualToString:@"GAMEOVER"]) {
        
        if ([[human state] isEqualToString:@"GAMEOVER"]) {
                AppController * app = (AppController *)[[UIApplication sharedApplication] delegate];
                [app setScore:totalScore andLevel:level];
                [self unschedule:@selector(randomItems)];
                CCScene * gOver = [gameOverScene scene];
                CCTransitionCrossFade * t = [CCTransitionCrossFade transitionWithDuration:0.5 scene:gOver];
                [[CCDirector sharedDirector] replaceScene:t];
        }
    }else{
        if ([itemsSpecialStage isEqualToString:@"JOHN"]) {
            [self randomItems];
        }else{
            [self randomEnemy];
        }
    }

    
    [self collisionItems];
    [self collisionEnemys];
    [self collisionBullet:delta];
}
/////////charector control///////////
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    float deceleration = 0.05f;//คำนวนค่าการเคลื่อนที่ ยิ่งน้อย ยิ่งเคลื่อนที่ไว
    float sensitivity = 20.0f;//คำนวนค่าเซนซิทิฟของการเอียง
    float maxVelocity = 100;
    if (acceleration.y < 0) {
        if (human != nil) {
            [human actionLeft];
        }
    }else if(acceleration.y > 0){
        if (human != nil) {
            [human actionRight];
        }
    }
    playerVelocity.x = playerVelocity.y * deceleration + acceleration.y * sensitivity;
    if(playerVelocity.x > maxVelocity){
        playerVelocity.x = maxVelocity;
//        NSLog(@"playerVelocity.x > maxVelocity");
    }else if (playerVelocity.x < - maxVelocity){
        playerVelocity.x = - maxVelocity;
//        NSLog(@"playerVelocity.x < - maxVelocity");
    }
}
- (void) updatePlayerAcc
{
    CGPoint pos = human.position;
    pos.x += playerVelocity.x;
    
    CGSize size = [CCDirector sharedDirector].winSize;
    float imgWidthHalved = 32;
    float leftBorderLimit = imgWidthHalved;
    float rightBorderLimit = size.width - imgWidthHalved;
    
    if(pos.x < leftBorderLimit){
        pos.x = leftBorderLimit;
        playerVelocity = CGPointZero;
        
    }else if (pos.x > rightBorderLimit){
        pos.x = rightBorderLimit;
        playerVelocity = CGPointZero;
        
    }
    human.position = pos;
}
-(void) controlCharector:(ccTime) deltaTime
{
    /* ทำให้ตัวละครเคลื่อนไหว */
    CGSize size = [[CCDirector sharedDirector] winSize];
    ///////
    CGPoint position = human.position;
    double newX = position.x + monsterSpeedX * deltaTime;
    double newY = position.y + monsterSpeedY * deltaTime;
    
    if (newX < 0)
    {
        newX = 0;
        monsterSpeedX = 0;
    }
    else if (newX > size.width)
    {
        newX = size.width;
        monsterSpeedX = 0;
    }
    if (newY < 0)
    {
        newY = 0;
        monsterSpeedY = 0;
    }
    else if (newY > size.height)
    {
        newY = size.height;
        monsterSpeedY = 0;
    }
    
    human.position = CGPointMake(newX, human.position.y);
    /* ทำให้ตัวละครเคลื่อนไหว */
}
/////////charector control///////////
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"BG Touch");
    return YES;
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
{
    NSLog(@"BG touched");
    [[SimpleAudioEngine sharedEngine] playEffect:@"shoot.mp3"];
    CCSprite * bullet = [CCSprite spriteWithFile:@"Fire.png"];
    bullet.anchorPoint = CGPointMake(0.5, 1);
    bullet.position = ccp(human.position.x, human.position.y);
    [self addChild:bullet z:4];
    [bulletArray addObject:bullet];

}
-(void)onExit
{
    [super onExit];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [self unscheduleUpdate];
}
-(void)dealloc
{
    [super dealloc];
}
@end
