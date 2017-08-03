//
//  AbstractDesignBaseCell.h
//  AbstractDesignDemo
//
//  Created by 技术部 on 17/7/28.
//  Copyright © 2017年 Mr Luo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractDesignBaseModel.h"

@interface AbstractDesignBaseCell : UITableViewCell

/**对应数据下标*/
@property (nonatomic, strong) NSIndexPath *indexPath;

/*!
 @brief 加载数据，有子类实现
 @param model 数据model，对应数据取model.dataArray[indexPath.row]
 */
- (void) updataWithModel:(AbstractDesignBaseModel *)model;

@end
