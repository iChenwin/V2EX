//
//  TopicListViewController.m
//  V2EX
//
//  Created by wayne on 2016/11/15.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import "TopicListViewController.h"
#import "TopicTableViewCell.h"
#import "WebViewController.h"
#import "MyFunc.h"
#import "NSObject+Function.h"
#import "Macro.h"

@interface TopicListViewController ()
@property (strong, nonatomic)NSDictionary *searchDict;
@property (strong, nonatomic)NSArray *topicArr;
@property (strong, nonatomic)UIViewController *fatherVC;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TopicListViewController

- (instancetype)initWithDict:(NSDictionary *)dict VC:(UIViewController *)vc{
    if (self = [super init]) {
        self.searchDict = [[NSDictionary alloc] initWithDictionary: dict];
        self.topicArr = [NSArray array];
        self.fatherVC = vc;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fatherVC.navigationController.navigationBar.hidden = YES;
    ASYNCQUEUE(^{
        self.topicArr = [MyFunc topicArrInNode:self.searchDict[@"nodeName"] withKeywordArr:self.searchDict[@"keywords"] andNumberOfTopics:[self.searchDict[@"count"] integerValue]];
        if (0 == [self.topicArr count]) {
            self.topicArr  = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:@"未找到结果" forKey:@"title"]];
        }
        [self.tableView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//    
//    [self doSomething:^{
//        self.topicArr = [MyFunc topicArrInNode:self.searchDict[@"nodeName"] withKeywordArr:self.searchDict[@"keywords"] andNumberOfTopics:[self.searchDict[@"count"] integerValue]];
//        dispatch_semaphore_signal(sema);
//    }];
//    
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.topicArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerNib: [UINib nibWithNibName:@"TopicTableViewCell" bundle:nil]  forCellReuseIdentifier:@"TopicTableViewCell"];
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.topicArr[indexPath.row];
    cell.titleLabel.text = dict[@"title"];
    cell.timeLabel.text = dict[@"time"];
    
    cell.userInteractionEnabled = YES;
    cell.tag = [dict[@"topicID"] integerValue];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTopic:)];
    [cell addGestureRecognizer:gesture];
    
//    if (indexPath.row == ([self.topicArr count] - 1)) {
//        [self.tableView setContentOffset:CGPointZero animated:YES];
//        [self viewDidLoad];
//    }
    
    return cell;
    
}

- (void)tappedTopic:(UITapGestureRecognizer *)sender {
    WebViewController *webVC = [[WebViewController alloc] initWithURLString:[NSString stringWithFormat:@"https://www.v2ex.com/t/%ld", sender.view.tag] andVC:self];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
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
