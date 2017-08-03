//
//  SubstanceOneModel.m
//  AbstractDesignDemo
//
//  Created by 技术部 on 17/7/28.
//  Copyright © 2017年 Mr Luo. All rights reserved.
//

#import "SubstanceOneModel.h"

@implementation SubstanceOneModel

- (CGFloat)rowHeight {
    return 100;
}

- (NSInteger)rows {
    return 2;
}

- (void)loadDataSuccess:(void (^)(id))success failure:(void (^)(void))failure {

    [self.dataArray addObject:@""];
    if (success) {
        success(self.dataArray);
    }

}


@end
