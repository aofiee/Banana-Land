//
//  items.h
//  Jurassic Pug
//
//  Created by Khomkrid Lerdprasert on 1/23/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface items : CCNode {
    NSMutableString * state;
    CCSprite * item;
}
@property (readonly) NSMutableString * state;
- (void) move:(CGPoint)point;
- (void) changeState:(NSMutableString*)s;
- (CGRect) itemBoundingBox;
@end
