//
//  ViewController.m
//  PetersLab
//
//  Created by suiming on 2021/10/30.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "ExposeManager.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray<NSString *> *cellArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
    }];
    
    for (int i=0; i< 10; i++) {
        NSString *tag = [NSString stringWithFormat:@"%d", i];
        [self.cellArray addObject:tag];
    }
    [self.tableView reloadData];
    
    // Do any additional setup after loading the view.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseid = @"reuseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseid];
    }
    NSString *exposeId = [NSString stringWithFormat:@"%ld - %ld",indexPath.section, indexPath.row];
    cell.textLabel.text = exposeId;
    
    
    // 曝光逻辑
    if (cell.exposeId.length > 0) {
        [ExposeManager removeDataFromPage:NSStringFromClass([self class]) componentName:@"CellView" dataId:cell.exposeId];
    }
    cell.exposeId = exposeId;
    [ExposeManager addDataForPage:NSStringFromClass([self class]) componentName:@"CellView" view:cell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // NSNumber *rowHeight = [self.cellHeightDataArr safeObjectAtIndex:indexPath.row];
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSMutableArray<NSString *> *)cellArray  {
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}

@end
