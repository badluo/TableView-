//
//  SubstanceThreeCell.m
//  AbstractDesignDemo
//
//  Created by 技术部 on 17/7/28.
//  Copyright © 2017年 Mr Luo. All rights reserved.
//

#import "SubstanceThreeCell.h"

@implementation SubstanceThreeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)updataWithModel:(AbstractDesignBaseModel *)model {
    
}

@end
