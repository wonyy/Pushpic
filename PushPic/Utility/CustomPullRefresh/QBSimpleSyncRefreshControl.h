//
//  QBSimpleSyncRefreshControl.h
//  QBRefreshControlDemo
//
//  Created by Katsuma Tanaka on 2012/11/23.
//  Copyright (c) 2012年 Katsuma Tanaka. All rights reserved.
//

#import "QBRefreshControl.h"

@interface QBSimpleSyncRefreshControl : QBRefreshControl
{
    BOOL isStartAnimation;
    int index;
    __weak QBSimpleSyncRefreshControl *waekObj;
}

@end
