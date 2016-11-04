//
//  items.m
//  Jurassic Pug
//
//  Created by Khomkrid Lerdprasert on 1/23/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import "items.h"


@implementation items
@synthesize state;
- (void) move:(CGPoint)point
{
    [self setPosition:point];
}
- (CGRect) itemBoundingBox
{
    CGSize s  = item.contentSize;
    s.width  = (s.width*(item.scaleX/2));// self.scaleX;// _scaleX;
    s.height = (s.height*(item.scaleY/2));// _scaleY;
    //    NSLog(@"s.width %f s.height %f",s.width,s.height);
    CGRect pathBox = CGRectMake(
                                _position.x-(s.width/2),// - (s.width-25),
                                _position.y + 1,
                                s.width,
                                s.height);
    return pathBox;
}
- (void) changeState:(NSMutableString*)s
{
    
}
-(void)dealloc
{
    [super dealloc];
    [state release];    
}
@end
