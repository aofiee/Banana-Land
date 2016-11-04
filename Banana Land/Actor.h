//
//  Actor.h
//  YingLak
//
//  Created by Khomkrid Lerdprasert on 2/22/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Actor : CCNode {
    int heart;
    int score;
    CCSprite * charectorSprite;
    NSMutableString * state, * reasonDie;
}
@property (readonly) NSMutableString * state, * reasonDie;
- (void) move:(CGPoint)point;
- (void) changeState:(NSMutableString*)s;
- (CGRect) actorBoundingBox;

@end
