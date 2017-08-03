//
//  AbstractDesignController.m
//  AbstractDesignDemo
//
//  Created by 技术部 on 17/7/28.
//  Copyright © 2017年 Mr Luo. All rights reserved.
//

#import "AbstractDesignController.h"
#import "AbstractDesignViewModel.h"

@interface AbstractDesignController ()

@property (nonatomic, strong) AbstractDesignViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AbstractDesignController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //先进行模型和视图实体配置
    NSArray *tempArray = @[@"SubstanceOneModel",@"SubstanceTowModel",@"SubstanceThreeModel"];
    NSArray *cellArray = @[@"SubstanceOneCell",@"SubstanceTowCell",@"SubstanceThreeCell"];
    NSInteger index = 0;
    for (NSString *model in tempArray) {
        [self.viewModel addSubstanceModelName:model];
        [self.viewModel addSubstanceCellName:cellArray[index]];
        index ++;
    }

    //设置视图显示顺序
    //@(0) yellow @(1) blue @(2) red
    [self.viewModel showOrders:@[@(1),@(0),@(2)]];
    
    //请求数据,刷新视图
    [self loadData];
    
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark getter
- (AbstractDesignViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[AbstractDesignViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self.viewModel;
        _tableView.delegate = self.viewModel;
    }
    return _tableView;
}

#pragma mark load data
- (void) loadData {
    __weak typeof(self) weakSelf = self;
    [self.viewModel loadDataSuccess:^(id data) {
        
    } failure:^{
        
    } reloadData:^(id data) {
        [weakSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
