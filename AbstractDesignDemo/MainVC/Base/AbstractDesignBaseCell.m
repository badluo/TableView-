//
//  AbstractDesignBaseCell.m
//  AbstractDesignDemo
//
//  Created by 技术部 on 17/7/28.
//  Copyright © 2017年 Mr Luo. All rights reserved.
//

#import "AbstractDesignBaseCell.h"

@implementation AbstractDesignBaseCell

/**
 * 子类实现
 */
- (void)updataWithModel:(AbstractDesignBaseModel *)model {
    @throw [NSException exceptionWithName:NSStringFromClass([self class]) reason:@"子类实现该方法" userInfo:nil];
}

@end
