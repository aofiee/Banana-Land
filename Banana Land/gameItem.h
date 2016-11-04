//
//  coinItem.h
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 4/15/2557 BE.
//  Copyright 2557 Twin Synergy Co., Ltd. All rights reserved.
//

#import "items.h"
@interface gameItem : items {
    int itemType;
}
-(void)randomItems:(int)n;
-(int)getItemType;
@end
