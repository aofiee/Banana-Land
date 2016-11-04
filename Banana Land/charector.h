//
//  charector.h
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 4/16/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import "Actor.h"

@interface charector : Actor {
    NSMutableString * actorName, * LRM;
}
@property (nonatomic,retain)    NSMutableString * actorName,* LRM;
- (void) changeState:(NSMutableString*)s;
-(void) createActor:(CCSpriteFrameCache*)frameCache;
-(void)setActorDisplay:(NSMutableString *)actor;
-(void)actionRight;
-(void)actionLeft;
@end
