//
//  AbstractDesignBaseModel.m
//  AbstractDesignDemo
//
//  Created by 技术部 on 17/7/28.
//  Copyright © 2017年 Mr Luo. All rights reserved.
//

#import "AbstractDesignBaseModel.h"

@implementation AbstractDesignBaseModel

-(CGFloat)rowHeight {
    return self.isShow?50:0.01;
}

- (CGFloat)headerHeight {
    return 0.01;
}

- (CGFloat)footerHeight {
    return self.isShow?10:0.01;
}

- (BOOL)isShow {
    if (self.remoteShow) {
        if (self.dataArray.count) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)showHeader {
    return NO;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

/**
 * 请求数据,子类实现
 */
- (void)loadDataSuccess:(void (^)(id))success failure:(void (^)(void))failure {
    @throw [NSException exceptionWithName:NSStringFromClass([self class]) reason:@"子类实现该方法" userInfo:nil];
}

@end
