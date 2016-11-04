//
//  selectCharectorScene.m
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 4/2/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import "selectCharectorScene.h"
#import "CCScrollLayer.h"
#import "SimpleAudioEngine.h"
#import "playScene.h"
#import "AppDelegate.h"
#define kSampleAdUnitID @"e1340c6beb484713"
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
@implementation selectCharectorScene
@synthesize interstitial_;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	selectCharectorScene *layer = [selectCharectorScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
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
		CGSize  size = [[CCDirector sharedDirector] winSize];
        if (IS_IPHONE5) {
            spacerItem = 2;
        }else{
            spacerItem = -12;
        }
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"selectplayer.mp3"];
        CCSpriteFrameCache * frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"charectorSet1.plist"];
        CCSpriteBatchNode * spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"charectorSet1.png"];
        [frameCache addSpriteFramesWithFile:@"charectorSet2.plist"];
        CCSpriteBatchNode * spriteSheet2 = [CCSpriteBatchNode batchNodeWithFile:@"charectorSet2.png"];
        [frameCache addSpriteFramesWithFile:@"charectorSet3.plist"];
        CCSpriteBatchNode * spriteSheet3 = [CCSpriteBatchNode batchNodeWithFile:@"charectorSet3.png"];
        [self addChild:spriteSheet z:0];
        [self addChild:spriteSheet2 z:0];
        [self addChild:spriteSheet3 z:0];

        CCSprite * bg = [CCSprite spriteWithFile:@"selecteCharectorBg.png"];
        bg.anchorPoint = CGPointMake(0.5, 0.5);
        bg.position = ccp(size.width/2, size.height/2);
        [self addChild:bg];
	}
	
	return self;
}
-(void)selectCharectorTouch:(id)sender
{
    interstitial_.delegate = nil;
    [interstitial_ release];
    
    AppController * app = (AppController *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];


    CCMenu * menu = (CCMenu*)sender;
    switch (menu.tag) {
        case 1:
        {
            [prefs setObject:@"Eskimo" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"Kluaythai.mp3"]];
        }
            break;
        case 2:
        {
            [prefs setObject:@"Cowboy" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"Cowboy.mp3"]];
        }
            break;
        case 3:
        {
            [prefs setObject:@"Toy" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"Toysakie.mp3"]];
        }
            break;
        case 4:
        {
            [prefs setObject:@"BRYAN" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"Bryan.mp3"]];
        }
            break;
        case 5:
        {
            [prefs setObject:@"Jane" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"Jane.mp3"]];
        }
            break;
        case 6:
        {
            [prefs setObject:@"Tor" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"RosesFall.mp3"]];
        }
            break;
        case 7:
        {
            [prefs setObject:@"Edit-Walnut" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"AppleGirlsBand.mp3"]];
        }
            break;
        case 8:
        {
            [prefs setObject:@"Jaroen" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"Jaroen.mp3"]];
        }
            break;
        case 9:
        {
            [prefs setObject:@"Joke" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"JohnnieRunner.mp3"]];
        }
            break;
        case 10:
        {
            [prefs setObject:@"TUM" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"PageUp.mp3"]];
        }
            break;
        case 11:
        {
            [prefs setObject:@"JOHN" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"ThemeSong.mp3"]];
        }
            break;
        case 12:
        {
            [prefs setObject:@"ART" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"Sudden.mp3"]];
        }
            break;
        case 13:
        {
            [prefs setObject:@"BON" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"Annalynn.mp3"]];
        }
            break;
        case 14:
        {
            [prefs setObject:@"Nay" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"NoGoatsNoGlory.mp3"]];
        }
            break;
        case 15:
        {
            [prefs setObject:@"Paul" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"Ugoslabier.mp3"]];
        }
            break;
        case 16:
        {
            [prefs setObject:@"Pound" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"Fathomless.mp3"]];
        }
            break;
        case 17:
        {
            [prefs setObject:@"InVein" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"InVein.mp3"]];
        }
            break;
        case 18:
        {
            [prefs setObject:@"KAN" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"kan.mp3"]];
        }
            break;
        default:
        {
            [prefs setObject:@"Toy" forKey:@"bananaland_session_playerSelected"];
            [app setMusicPlayerSelected:[NSMutableString stringWithString:@"Toysakie.mp3"]];
        }
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    CCScene * play = [playScene scene];
    CCTransitionCrossFade * t = [CCTransitionCrossFade transitionWithDuration:0.5 scene:play];
    [[CCDirector sharedDirector] replaceScene:t];
}
-(CCMenu*)createCharectorMenu1
{
    CGSize  size = [[CCDirector sharedDirector] winSize];
    CCMenuItemImage * eskimo = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"eskimoN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"eskimoH.png"] target:self selector:@selector(selectCharectorTouch:)];
    eskimo.tag = 1;
    eskimo.anchorPoint = CGPointMake(0, 1);
    eskimo.position = ccp(0, 0);
    eskimo.normalImage.position = ccp(0, 0);
    eskimo.selectedImage.position = ccp(eskimo.normalImage.position.x, eskimo.normalImage.position.y);
    
    CCMenuItemImage * cowboy = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"cowboyN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"cowboyH.png"] target:self selector:@selector(selectCharectorTouch:)];
    cowboy.tag = 2;
    cowboy.anchorPoint = CGPointMake(0, 1);
    cowboy.position = ccp(eskimo.position.x+eskimo.contentSize.width+spacerItem, eskimo.position.y);
    cowboy.normalImage.position = ccp(0, 0);
    cowboy.selectedImage.position = ccp(cowboy.normalImage.position.x, cowboy.normalImage.position.y);

    CCMenuItemImage * toy = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"toyN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"toyH.png"] target:self selector:@selector(selectCharectorTouch:)];
    toy.tag = 3;
    toy.anchorPoint = CGPointMake(0, 1);
    toy.position = ccp(cowboy.position.x+cowboy.contentSize.width+spacerItem, cowboy.position.y);
    toy.normalImage.position = ccp(0, 0);
    toy.selectedImage.position = ccp(toy.normalImage.position.x, toy.normalImage.position.y);

    CCMenuItemImage * byan = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"byanN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"byanH.png"] target:self selector:@selector(selectCharectorTouch:)];
    byan.tag = 4;
    byan.anchorPoint = CGPointMake(0, 1);
    byan.position = ccp(toy.position.x+toy.contentSize.width+spacerItem, toy.position.y);
    byan.normalImage.position = ccp(0, 0);
    byan.selectedImage.position = ccp(byan.normalImage.position.x, byan.normalImage.position.y);
    
    CCMenuItemImage * jane = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"janeN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"janeH.png"] target:self selector:@selector(selectCharectorTouch:)];
    jane.tag = 5;
    jane.anchorPoint = CGPointMake(0, 1);
    jane.position = ccp(byan.position.x+byan.contentSize.width+spacerItem, byan.position.y);
    jane.normalImage.position = ccp(0, 0);
    jane.selectedImage.position = ccp(jane.normalImage.position.x, jane.normalImage.position.y);
    
    CCMenuItemImage * tor = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"torN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"torH.png"] target:self selector:@selector(selectCharectorTouch:)];
    tor.tag = 6;
    tor.anchorPoint = CGPointMake(0, 1);
    tor.position = ccp(eskimo.position.x, eskimo.position.y-eskimo.contentSize.height-25);
    tor.normalImage.position = ccp(0, 0);
    tor.selectedImage.position = ccp(tor.normalImage.position.x, tor.normalImage.position.y);

    CCMenuItemImage * walnut = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"walnutN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"walnutH.png"] target:self selector:@selector(selectCharectorTouch:)];
    walnut.tag = 7;
    walnut.anchorPoint = CGPointMake(0, 1);
    walnut.position = ccp(tor.position.x+tor.contentSize.width+spacerItem, tor.position.y);
    walnut.normalImage.position = ccp(0, 0);
    walnut.selectedImage.position = ccp(walnut.normalImage.position.x, walnut.normalImage.position.y);
    
    CCMenuItemImage * jaroen = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"jaroenN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"jaroenH.png"] target:self selector:@selector(selectCharectorTouch:)];
    jaroen.tag = 8;
    jaroen.anchorPoint = CGPointMake(0, 1);
    jaroen.position = ccp(walnut.position.x+walnut.contentSize.width+spacerItem, walnut.position.y);
    jaroen.normalImage.position = ccp(0, 0);
    jaroen.selectedImage.position = ccp(jaroen.normalImage.position.x, jaroen.normalImage.position.y);

    CCMenuItemImage * joke = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"jokeN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"jokeH.png"] target:self selector:@selector(selectCharectorTouch:)];
    joke.tag = 9;
    joke.anchorPoint = CGPointMake(0, 1);
    joke.position = ccp(jaroen.position.x+jaroen.contentSize.width+spacerItem, jaroen.position.y);
    joke.normalImage.position = ccp(0, 0);
    joke.selectedImage.position = ccp(joke.normalImage.position.x, joke.normalImage.position.y);
    
    CCMenuItemImage * tum = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"tumN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"tumH.png"] target:self selector:@selector(selectCharectorTouch:)];
    tum.tag = 10;
    tum.anchorPoint = CGPointMake(0, 1);
    tum.position = ccp(joke.position.x+joke.contentSize.width+spacerItem, joke.position.y);
    tum.normalImage.position = ccp(0, 0);
    tum.selectedImage.position = ccp(tum.normalImage.position.x, tum.normalImage.position.y);
    
    CCMenu * charMenu = [CCMenu menuWithItems:eskimo,cowboy,toy,byan,jane,tor,walnut,jaroen,joke,tum, nil];
    charMenu.anchorPoint = CGPointMake(0, 1);
    charMenu.position = ccp((size.width/2)-((eskimo.contentSize.width+spacerItem)*5)/2,size.height-5);
    
    return charMenu;
}
-(CCMenu*)createCharectorMenu2
{
    CGSize  size = [[CCDirector sharedDirector] winSize];
    CCMenuItemImage * john = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"johnN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"johnH.png"] target:self selector:@selector(selectCharectorTouch:)];
    john.tag = 11;
    john.anchorPoint = CGPointMake(0, 1);
    john.position = ccp(0, 0);
    john.normalImage.position = ccp(0, 0);
    john.selectedImage.position = ccp(john.normalImage.position.x, john.normalImage.position.y);
    
    CCMenuItemImage * art = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"artN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"artH.png"] target:self selector:@selector(selectCharectorTouch:)];
    art.tag = 12;
    art.anchorPoint = CGPointMake(0, 1);
    art.position = ccp(john.position.x+john.contentSize.width+spacerItem, john.position.y);
    art.normalImage.position = ccp(0, 0);
    art.selectedImage.position = ccp(art.normalImage.position.x, art.normalImage.position.y);
    
    CCMenuItemImage * bon = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bonN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bonH.png"] target:self selector:@selector(selectCharectorTouch:)];
    bon.tag = 13;
    bon.anchorPoint = CGPointMake(0, 1);
    bon.position = ccp(art.position.x+art.contentSize.width+spacerItem, art.position.y);
    bon.normalImage.position = ccp(0, 0);
    bon.selectedImage.position = ccp(bon.normalImage.position.x, bon.normalImage.position.y);
    
    CCMenuItemImage * nay = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"nayN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"nayH.png"] target:self selector:@selector(selectCharectorTouch:)];
    nay.tag = 14;
    nay.anchorPoint = CGPointMake(0, 1);
    nay.position = ccp(bon.position.x+bon.contentSize.width+spacerItem, bon.position.y);
    nay.normalImage.position = ccp(0, 0);
    nay.selectedImage.position = ccp(nay.normalImage.position.x, nay.normalImage.position.y);
    
    
    CCMenuItemImage * paul = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"paulN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"paulH.png"] target:self selector:@selector(selectCharectorTouch:)];
    paul.tag = 15;
    paul.anchorPoint = CGPointMake(0, 1);
    paul.position = ccp(john.position.x, john.position.y-john.contentSize.height-25);
    paul.normalImage.position = ccp(0, 0);
    paul.selectedImage.position = ccp(paul.normalImage.position.x, paul.normalImage.position.y);
    
    CCMenuItemImage * pound = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pondN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"pondH.png"] target:self selector:@selector(selectCharectorTouch:)];
    pound.tag = 16;
    pound.anchorPoint = CGPointMake(0, 1);
    pound.position = ccp(paul.position.x+paul.contentSize.width+spacerItem, paul.position.y);
    pound.normalImage.position = ccp(0, 0);
    pound.selectedImage.position = ccp(paul.normalImage.position.x, paul.normalImage.position.y);
    
    CCMenuItemImage * invein = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"invenN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"invenH.png"] target:self selector:@selector(selectCharectorTouch:)];
    invein.tag = 17;
    invein.anchorPoint = CGPointMake(0, 1);
    invein.position = ccp(pound.position.x+pound.contentSize.width+spacerItem, pound.position.y);
    invein.normalImage.position = ccp(0, 0);
    invein.selectedImage.position = ccp(invein.normalImage.position.x, invein.normalImage.position.y);
    
    CCMenuItemImage * kan = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"kanN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"kanH.png"] target:self selector:@selector(selectCharectorTouch:)];
    kan.tag = 18;
    kan.anchorPoint = CGPointMake(0, 1);
    kan.position = ccp(invein.position.x+invein.contentSize.width+spacerItem, invein.position.y);
    kan.normalImage.position = ccp(0, 0);
    kan.selectedImage.position = ccp(kan.normalImage.position.x, kan.normalImage.position.y);
    
    CCMenu * charMenu = [CCMenu menuWithItems:john,art,bon,nay,paul,pound,invein,kan, nil];
    charMenu.anchorPoint = CGPointMake(0, 1);
    charMenu.position = ccp((size.width/2)-((john.contentSize.width+spacerItem)*4)/2,size.height-5);
    
    return charMenu;
}
-(void)onEnter
{
    [super onEnter];
    [self createBanner];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"selectplayer.mp3"];
    CGSize  size = [[CCDirector sharedDirector] winSize];
    CCLayer * pageOne = [[CCLayer alloc] init];
    CCLayer * pageTwo = [[CCLayer alloc] init];

    CCSprite * textP1 = [CCSprite spriteWithSpriteFrameName:@"selectCharectorText.png"];
    textP1.anchorPoint = CGPointMake(0.5, 0.5);
    textP1.position = ccp(size.width/2, size.height/2);
    [pageOne addChild:textP1 z:1];
    
    CCSprite * next = [CCSprite spriteWithSpriteFrameName:@"arrow.png"];
    next.anchorPoint = CGPointMake(0.5, 0.5);
    next.position = ccp(size.width-next.contentSize.width, size.height/2);
    [pageOne addChild:next];
    
    [pageOne addChild:[self createCharectorMenu1] z:2];
    
    
    CCSprite * textP2 = [CCSprite spriteWithSpriteFrameName:@"selectCharectorText.png"];
    textP2.anchorPoint = CGPointMake(0.5, 0.5);
    textP2.position = ccp(size.width/2, size.height/2);
    [pageTwo addChild:textP2 z:1];
    
    CCSprite * prev = [CCSprite spriteWithSpriteFrameName:@"arrow.png"];
    prev.anchorPoint = CGPointMake(0.5, 0.5);
    prev.position = ccp(prev.contentSize.width, size.height/2);
    prev.flipX = YES;
    [pageTwo addChild:prev];
    
    [pageTwo addChild:[self createCharectorMenu2]];
    
    CCScrollLayer * scroller = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects: pageOne,pageTwo, nil] widthOffset:0];//offset 40
    scroller.showPagesIndicator = NO;
    scroller.tag = 101;
    [self addChild:scroller z:101];
}
-(void)dealloc
{
    [super dealloc];
}
-(void)onExit
{
    [super onExit];
}
@end
