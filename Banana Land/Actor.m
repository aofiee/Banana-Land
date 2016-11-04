//
//  Actor.m
//  YingLak
//
//  Created by Khomkrid Lerdprasert on 2/22/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import "Actor.h"


@implementation Actor
@synthesize state;
@synthesize reasonDie;
- (void) move:(CGPoint)point
{
    [self setPosition:point];
}
- (CGRect) actorBoundingBox
{
    CGSize s  = charectorSprite.contentSize;
    s.width  = (s.width*(charectorSprite.scaleX/2));
    s.height = s.height;//(s.height*(charector.scaleY/2))-55;
    CGRect pathBox = CGRectMake(
                                _position.x-(s.width/2),
                                0,//_position.y + 1,
                                s.width,
                                s.height);
    return pathBox;
}
-(NSMutableString*)getReasonDeath
{
    return reasonDie;
}
- (void) changeState:(NSMutableString*)s
{
    
}
-(void)dealloc
{
    [charectorSprite release];
    [state release];
    [reasonDie release];
    [super dealloc];
}
@end
