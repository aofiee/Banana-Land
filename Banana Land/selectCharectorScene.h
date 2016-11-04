//
//  selectCharectorScene.h
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 4/2/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//
#import "cocos2d.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
@interface selectCharectorScene : CCLayer <GADInterstitialDelegate> {
    float spacerItem;
}
+(CCScene *) scene;
@property (nonatomic,strong)    GADInterstitial * interstitial_;
@end
