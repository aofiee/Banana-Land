//
//  johnVideo.m
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 5/2/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import "johnVideo.h"
#import "menuScene.h"
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@implementation johnVideo
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	johnVideo *layer = [johnVideo node];
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(id) init
{
	if( (self=[super init])) {

        [CCVideoPlayer setDelegate: self];
    }

    return self;
}
- (void) moviePlaybackFinished
{
    [[CCDirector sharedDirector] startAnimation];
    [CCVideoPlayer setDelegate:nil];
    [self endScreen];
}

- (void) movieStartsPlaying
{
    [[CCDirector sharedDirector] stopAnimation];
}
-(void)onEnter{
    [super onEnter];
    [CCVideoPlayer playMovieWithFile:@"logointru_L.mp4"];
    [CCVideoPlayer setNoSkip:NO];
}

-(void)endScreen{
    CCScene * menu = [menuScene scene];
    CCTransitionCrossFade * t = [CCTransitionCrossFade transitionWithDuration:0.5 scene:menu];
    [[CCDirector sharedDirector] replaceScene:t];
}
-(void)onExit
{
    [super onExit];
}
@end
