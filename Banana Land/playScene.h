//
//  playScene.h
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 4/15/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "gameItem.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "charector.h"
#define PTM_RATIO 32
#import "CCShake.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@interface playScene : CCLayer <GADInterstitialDelegate>{
    gameItem * coins,* enemy;
    NSMutableArray * coinsArray, * enemyArray, * bulletArray, * heartArray;
    int itemsNum, enemyNum;
	b2World* _world;
    b2Body *_body;
	GLESDebugDraw *m_debugDraw;
    charector * human;
    float bulletSpeed , scrollSpeed, jumpSpeed , itemTimmer;
    CGPoint playerVelocity;
    double monsterSpeedX;
    double monsterSpeedY;
    
    CCLabelTTF * scoreLabel, * levelUpText, * powerLabel;
    NSMutableString * itemsSpecialStage, * playerName;
    int coinsScore, bananaScore, hotdogScore, guitarScore, moneyScore, totalScore, enemyScore;
    int level;
    CCProgressTimer * healthBar;
}
+(CCScene *) scene;
@property (nonatomic,strong)    GADInterstitial * interstitial_;
@end
