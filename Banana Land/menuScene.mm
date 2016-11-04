//
//  menuScene.m
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 4/2/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import "menuScene.h"
#import "SimpleAudioEngine.h"
#import "selectCharectorScene.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
@implementation menuScene
@synthesize webView;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	menuScene *layer = [menuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(id) init
{
	if( (self=[super init])) {
		
        CCSpriteFrameCache * frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"menuScene.plist"];
        CCSpriteBatchNode * spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"menuScene.png"];
        [self addChild:spriteSheet z:0];
        
		[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"ThemeSong.mp3"];
		CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite * bg = [CCSprite spriteWithFile:@"bgMenuScene.png"];
        bg.anchorPoint = CGPointMake(0.5, 0.5);
        bg.position = ccp(size.width/2, size.height/2);
        [self addChild:bg z:0];
	}
	
	return self;
}
-(void)btnTouch:(id)sender
{
    CCMenu * tmp = (CCMenu*)sender;
    switch (tmp.tag) {
        case 1:
        {
            CCScene * selectScene = [selectCharectorScene scene];
            CCTransitionMoveInR * t = [CCTransitionMoveInR transitionWithDuration:0.5 scene:selectScene];
            [[CCDirector sharedDirector] replaceScene:t];
        }
            break;
        case 2:
        {
            AppController *app = (AppController*)[UIApplication sharedApplication].delegate;
            if(app.session.isOpen){
                [app.session closeAndClearTokenInformation];
                CCMenuItemImage * toggleItem = (CCMenuItemImage*)sender;
                [toggleItem setNormalImage:[CCSprite spriteWithSpriteFrameName:@"fbLogout.png"]];
            }else{
                [app openSession];
                CCMenuItemImage * toggleItem = (CCMenuItemImage*)sender;
                [toggleItem setNormalImage:[CCSprite spriteWithSpriteFrameName:@"fbN.png"]];
            }
        }
            break;
        case 3:
        {
            NSURL *webURL = [NSURL URLWithString:@"http://www.twinsynergy.co.th/"];
            [[UIApplication sharedApplication] openURL: webURL];
        }
            break;
        case 4:
        {
            CGSize s = [[CCDirector sharedDirector] winSize];
            CGRect webFrame = CGRectMake(s.width/2, s.height/2, s.width-10, s.height-10);
            webView = [[[UIWebView alloc] initWithFrame:webFrame] autorelease];
            webView.delegate = self;
            webView.scalesPageToFit = YES;
            [webView setOpaque:YES];
            [webView setBackgroundColor:[UIColor whiteColor]];
            
            [webView setCenter:CGPointMake(s.width/2, s.height/2)];
            
            UIImage *img = [UIImage imageNamed:@"closeN.png"];
            UIImage * imgAc = [UIImage imageNamed:@"closeH.png"];
            UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(s.width - 5 - img.size.width, 5, img.size.width, img.size.height)];
            [closeBtn setImage:img forState:UIControlStateNormal];
            [closeBtn setImage:imgAc forState:UIControlStateHighlighted];
            [closeBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [webView addSubview:closeBtn];
            
            [[[CCDirector sharedDirector] openGLView] addSubview:webView];
            
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test.khomkrid.com/bananaland/"]];
            [webView loadRequest:requestObj];
        }
            break;
        default:
            break;
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = [[CCDirector sharedDirector] openGLView].bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    theWebView.scrollView.minimumZoomScale = rw;
    theWebView.scrollView.maximumZoomScale = rw;
    theWebView.scrollView.zoomScale = rw;
}
-(void)buttonPressed:(id)sender
{
    [webView removeFromSuperview];
}
-(void) onEnter
{
	[super onEnter];
    CGSize size = [[CCDirector sharedDirector] winSize];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ThemeSong.mp3"];
    
    CCSprite * world = [CCSprite spriteWithSpriteFrameName:@"world.png"];
    world.anchorPoint = CGPointMake(0.5, 0.5);
    world.position = ccp(size.width/2, size.height/2);
    [self addChild:world z:2];
    [world runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5.0 angle:360]]];
    
    CCSprite * jhone = [CCSprite spriteWithSpriteFrameName:@"jhoneLogo.png"];
    jhone.anchorPoint = CGPointMake(0.5, 0.5);
    jhone.position = ccp(size.width/2, (size.height/2)+30);
    [self addChild:jhone z:3];
    jhone.scale = 0;
    CCSequence * sq = [CCSequence actions:
                            [CCScaleTo actionWithDuration:0.2 scale:1.5],
                            [CCScaleTo actionWithDuration:0.2 scale:1.0]
                       , nil];
    [jhone runAction:sq];
    

    CCMenuItemImage * playBtn = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"playN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"playH.png"] target:self selector:@selector(btnTouch:)];
    playBtn.tag = 1;
    playBtn.position = ccp(0, 0);
    playBtn.normalImage.position = ccp(0, 0);
    playBtn.selectedImage.position = ccp(playBtn.normalImage.position.x, playBtn.normalImage.position.y);
    
    AppController *app = (AppController*)[UIApplication sharedApplication].delegate;

    NSString * fbBtSkin = nil;
    if(app.session.isOpen){
        fbBtSkin = @"fbLogout.png";
    }else{
        fbBtSkin = @"fbN.png";
    }
    
    CCMenuItemImage * fbBtn = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:fbBtSkin] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"fbH.png"] target:self selector:@selector(btnTouch:)];
    fbBtn.tag = 2;
    fbBtn.position = ccp(playBtn.position.x, playBtn.position.y-(playBtn.contentSize.height));
    fbBtn.normalImage.position = ccp(0, 0);
    fbBtn.selectedImage.position = ccp(fbBtn.normalImage.position.x, fbBtn.normalImage.position.y);
    
    CCMenuItemImage * creditBtn = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"crN.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"crH.png"] target:self selector:@selector(btnTouch:)];
    creditBtn.tag = 3;
    creditBtn.position = ccp(creditBtn.position.x, fbBtn.position.y-(fbBtn.contentSize.height));
    creditBtn.normalImage.position = ccp(0, 0);
    creditBtn.selectedImage.position = ccp(creditBtn.normalImage.position.x, creditBtn.normalImage.position.y);

    CCMenuItemImage * scoreBtn = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithFile:@"scoreBtnN.png"] selectedSprite:[CCSprite spriteWithFile:@"scoreBtnH.png"] target:self selector:@selector(btnTouch:)];
    scoreBtn.tag = 4;
    scoreBtn.position = ccp(0,0);
    scoreBtn.normalImage.position = ccp(0, 0);
    scoreBtn.selectedImage.position = ccp(scoreBtn.normalImage.position.x, scoreBtn.normalImage.position.y);
    
    CCMenu * menu = [CCMenu menuWithItems:playBtn,fbBtn,creditBtn, nil];
    menu.anchorPoint = CGPointMake(0.5, 0.5);
    menu.position = ccp(size.width-playBtn.contentSize.width-10, (size.height/2)+playBtn.contentSize.height);
    [self addChild:menu z:3];
    
    CCMenu * menu2 = [CCMenu menuWithItems:scoreBtn, nil];
    menu2.anchorPoint = CGPointMake(0.5, 0.5);
    menu2.position = ccp(scoreBtn.contentSize.width, size.height/2);
    [self addChild:menu2 z:3];
    
    [self createCloud];
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
@end
