//
//  AppDelegate.h
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 4/2/2557 BE.
//  Copyright Twin Synergy Co., Ltd. 2557. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import <FacebookSDK/FacebookSDK.h>
// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;
	NSMutableString  * musicPlayerSelected, * postScoreStage;
	CCDirectorIOS	*director_;							// weak ref
    
    int m_coinsScore, m_bananaScore, m_hotdogScore, m_guitarScore, m_moneyScore, m_totalScore, m_level;
}
@property (strong, nonatomic) FBSession *session;
@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic,retain)  NSMutableString  * musicPlayerSelected,* postScoreStage;
-(void)setmusicPlayerSelected:(NSMutableString*)str;
-(NSMutableString*)getmusicPlayerSelected;
-(void)setScore:(int)score andLevel:(int)level;
-(int)getLevel;
-(int)getScore;
- (void)openSession;
-(NSMutableString*)getPostScoreStage;
-(void)postScoreToFaceBook:(UIImage*)img;
@end
