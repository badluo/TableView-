//
//  AbstractDesignViewModel.m
//  AbstractDesignDemo
//
//  Created by 技术部 on 17/7/28.
//  Copyright © 2017年 Mr Luo. All rights reserved.
//

#import "AbstractDesignViewModel.h"
#import "AbstractDesignBaseModel.h"
#import "AbstractDesignBaseCell.h"
#import "AbstractDesignBaseHeader.h"

@interface AbstractDesignViewModel ()

/**存放模型*/
@property (nonatomic, strong) NSMutableArray *models;

/**存放视图名称*/
@property (nonatomic, strong) NSMutableArray *cellNames;

/**
 * 当前显示的视图，里面存放当前视图的位置，根据它去modelNames和cellNames里面取对应model和cell
 * 存放number类型数据，number的值对应model，cell在modelNames和cellNames里面的下标
 */
@property (nonatomic, strong) NSMutableArray *orderPlaces;

@end

@implementation AbstractDesignViewModel

#pragma mark setter && getter
- (NSMutableArray *)models {
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (NSMutableArray *)cellNames {
    if (!_cellNames) {
        _cellNames = [NSMutableArray array];
    }
    return _cellNames;
}

- (NSMutableArray *)orderPlaces {
    if (!_orderPlaces) {
        _orderPlaces = [NSMutableArray array];
    }
    return _orderPlaces;
}

#pragma mark 请求数据
- (void)loadDataSuccess:(void (^)(id))success failure:(void (^)(void))failure reloadData:(void (^)(id))reloadData{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t serialQueue = dispatch_queue_create("com.lj.demo.www", DISPATCH_QUEUE_SERIAL);
    //请求显示对应视图的数据，这里每个视图的数据是分开请求，显示的视图才请求
    for (AbstractDesignBaseModel *model in self.models) {
        if (model.remoteShow) {
            dispatch_group_enter(group);
            dispatch_group_async(group, serialQueue, ^{
                [model loadDataSuccess:^(id data) {
                    if (success) {
                        success(data);
                    }
                    dispatch_group_leave(group);
                } failure:^{
                    if (failure) {
                        failure();
                    }
                    dispatch_group_leave(group);
                }];
            });
        }
    }
    
    __weak typeof(self) weakSelf = self;
    // 所有网络请求结束后会来到这个方法
    dispatch_group_notify(group, serialQueue, ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                // 刷新UI
                if (reloadData) {
                    reloadData(weakSelf.models);
                }
            });
        });
    });
}

#pragma mark 实体添加操作
- (void)addSubstanceCellName:(NSString *)cellName {
    [self.cellNames addObject:cellName];
}

- (void)addSubstanceModelName:(NSString *)modelName {
    AbstractDesignBaseModel *model = [[NSClassFromString(modelName) alloc] init];
    [self.models addObject:model];
    NSInteger order = [self.models indexOfObject:model];
    [self.orderPlaces addObject:@(order)];
}

- (void)showOrders:(NSArray *)orders {
    [self sortRankWithShowArray:orders];
}

/**
 * 根据要展示的视图的顺序，整理显示视图
 */
- (void) sortRankWithShowArray:(NSArray *)showArray {
    NSMutableArray *tempOrderPlaceArray = self.orderPlaces;
    [tempOrderPlaceArray removeObjectsInArray:showArray];
    NSMutableArray *rusultPlaceArray = [showArray mutableCopy];
    for (NSNumber *number in showArray) {//显示
        AbstractDesignBaseModel *model = self.models[number.integerValue];
        model.remoteShow = YES;
    }
    for (NSNumber *number in tempOrderPlaceArray) {//不显示
        AbstractDesignBaseModel *model = self.models[number.integerValue];
        model.remoteShow = NO;
        [rusultPlaceArray addObject:number];
    }
    self.orderPlaces = rusultPlaceArray;
}

#pragma mark table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderPlaces.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AbstractDesignBaseModel *model = [self getCurrentSectionModelAtRow:0 inSection:section];
    return model.rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //用对应模型来处理视图
    AbstractDesignBaseModel *model = [self getCurrentSectionModelAtRow:indexPath.row inSection:indexPath.section];
    if (model.isShow) {
        AbstractDesignBaseCell *cell = [self tableView:tableView indexPath:indexPath model:model];
        //数据添加处理
        /*
         .....
         */
        cell.indexPath = indexPath;
        [cell updataWithModel:model];
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"originCell"];
        if (cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"originCell"];
        }
        return cell;
    }
    
}

#pragma mark table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AbstractDesignBaseModel *model = [self getCurrentSectionModelAtRow:indexPath.row inSection:indexPath.section];
    return model.rowHeight;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AbstractDesignBaseModel *model = [self getCurrentSectionModelAtRow:0 inSection:section];
    if (model.showHeader) {
        AbstractDesignBaseHeader *header = [[AbstractDesignBaseHeader alloc] init];
        return  header;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    AbstractDesignBaseModel *model = [self getCurrentSectionModelAtRow:0 inSection:section];
    return model.headerHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    AbstractDesignBaseModel *model = [self getCurrentSectionModelAtRow:0 inSection:section];
    return model.footerHeight;
}

#pragma mark private

/**
 *  根据模型创建cell
 */
- (AbstractDesignBaseCell *)tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(AbstractDesignBaseModel *)model {
    NSString *cellIdentifier = [self getCurrentSectionCellAtRow:indexPath.row inSection:indexPath.section];
    AbstractDesignBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (model.isXib) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil] lastObject];
    }else {
        cell = [[NSClassFromString(cellIdentifier) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 * 将系统返回的下标进行转换，转换为与产品位置对应的下标
 */
- (NSIndexPath *)indexPathAtRow:(NSInteger)row inSection:(NSInteger)section {
    NSNumber *index = self.orderPlaces[section];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:[index integerValue]];
    return indexPath;
}

/**
 * 拿到当前section对应模型对象
 */
- (AbstractDesignBaseModel *)getCurrentSectionModelAtRow:(NSInteger)row inSection:(NSInteger)section {
    NSIndexPath *idxPath = [self indexPathAtRow:row inSection:section];
    AbstractDesignBaseModel *model = self.models[idxPath.section];
    return model;
}

/**
 * 拿到当前section对应的cell名称
 */
- (NSString *) getCurrentSectionCellAtRow:(NSInteger)row inSection:(NSInteger)section {
    NSIndexPath *idxPath = [self indexPathAtRow:row inSection:section];
    return self.cellNames[idxPath.section];
}






@end
