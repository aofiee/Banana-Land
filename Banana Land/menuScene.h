//
//  menuScene.h
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 4/2/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import "cocos2d.h"
@interface menuScene : CCLayer <UIWebViewDelegate>{
    UIWebView * webView;
}
+(CCScene *) scene;
@property (nonatomic,retain)    UIWebView * webView;
@end
