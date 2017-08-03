//
//  AbstractDesignBaseModel.h
//  AbstractDesignDemo
//
//  Created by 技术部 on 17/7/28.
//  Copyright © 2017年 Mr Luo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * 对应section的数据模型，一些参数可要可不要，自己根据情况定制
 */

@interface AbstractDesignBaseModel : NSObject

/**控制模型对应的视图显示与不显示*/
@property (nonatomic, assign) BOOL remoteShow;

/**根据是否有数据和remoteShow判断是否显示当前section*/
@property (nonatomic, assign,getter=isShow) BOOL show;

/**每个section的rows*/
@property (nonatomic, assign) NSInteger rows;

/**该模型对应视图是否是xib创建*/
@property (nonatomic, assign,getter=isXib) BOOL xib;

/**row高度,默认50*/
@property (nonatomic, assign) CGFloat rowHeight;

/**对应section的header高度，默认0.01*/
@property (nonatomic, assign) CGFloat headerHeight;

/**对应sectionfooter高度,默认10*/
@property (nonatomic, assign) CGFloat footerHeight;

/**该section对应的数据*/
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL showHeader;

/*!
 @brief 请求对应section的数据,子类实现
 */
- (void)loadDataSuccess:(void (^)(id data))success failure:(void (^)(void))failure;

@end
