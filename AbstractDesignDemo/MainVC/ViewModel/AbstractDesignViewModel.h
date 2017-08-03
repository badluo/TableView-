//
//  AbstractDesignViewModel.h
//  AbstractDesignDemo
//
//  Created by 技术部 on 17/7/28.
//  Copyright © 2017年 Mr Luo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * 处理视图逻辑视图模型，用抽象的AbstractDesignBaseModel和抽象的AbstractDesignBaseCell将数据和视图关联起来
 */

@interface AbstractDesignViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>

/*!
 @brief 添加实体模型，该模型实际上对应的是一个section的模型,通过模型名称创建模型,模型与视图需要一一对应
 @param modelName 待添加模型名称
 */
- (void) addSubstanceModelName:(NSString *)modelName;

/*!
 @brief 添加实体视图，添加的cell为当前section的cell，通过视图名称创建视图,模型与视图需要一一对应
 @param cellName 待添加视图名称
 */
- (void) addSubstanceCellName:(NSString *)cellName;

/*!
 @brief 添加完实体模型和视图，添加他们的显示顺序，如果不显示，不添加即可，实体的默认顺序和添加顺序一样，如：默认添加orders为：@[@(0),@(1),@(2),@(3),@(4)]，当要改变顺序显示：@[@(3),@(4),@(1),@(2),@(0)],也可：@[@(3),@(1),@(0)]传入下面方法，reloadData即可,该方法需要所有实体添加完成调用
 @param orders 要改变顺序的数组
 */
- (void) showOrders:(NSArray *)orders;

/*!
 @brief 数据请求，根据自身项目需求请求数据，在本项目中，每个section的数据时从不同接口获取的，因此需要多次请求，利用GCD实现请求完成统一刷新
 @param success 单次数据请求成功，可以刷新界面，data参数根据实际情况变动
 @param failure 单次数据请求失败
 @param reloadData 所有数据请求完成，单次数据可能失败，可能成功，可以统一刷新界面,data为所有模型数组
 */
- (void) loadDataSuccess:(void(^)(id data))success failure:(void(^)(void))failure  reloadData:(void(^)(id data))reloadData;

@end
