//
//  SecondViewController.m
//  V2EX
//
//  Created by wayne on 16/10/17.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import "SecondViewController.h"
#import "AFNetworking.h"
#import "TopicTableViewCell.h"
#import "WebViewController.h"

@interface SecondViewController ()
@property (strong, nonatomic) NSMutableArray *topicArr;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerNib:[UINib nibWithNibName:@"TopicTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TopicTableViewCell"];
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicTableViewCell" forIndexPath:indexPath];
    
    if ([self.topicArr count]) {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.topicArr[indexPath.row][@"title"]];
        double timeStamp = [self.topicArr[indexPath.row][@"created"] doubleValue];
        NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        
        //用于格式化NSDate对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式：zzz表示时区
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //NSDate转NSString
        NSString *timeString = [dateFormatter stringFromDate:createdDate];
        
        cell.timeLabel.text = timeString;
        
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopicCell:)];
        cell.tag = [self.topicArr[indexPath.row][@"id"] integerValue];
        [cell addGestureRecognizer:tapCell];
    }
    
    return cell;
}

- (void)tapTopicCell:(UITapGestureRecognizer *)sender {
    WebViewController *webVC = [[WebViewController alloc] initWithURLString:[NSString stringWithFormat:@"https://www.v2ex.com/t/%ld", sender.view.tag] andVC:self];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSArray *response;
    
    [manager GET:@"https://www.v2ex.com/api/topics/show.json?node_name=mbp" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        response = [[NSMutableArray alloc] initWithArray:responseObject];
        dispatch_semaphore_signal(semaphore);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    self.topicArr = [[NSMutableArray alloc] initWithArray:response];
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == [self.topicArr count])
        return 1;
    else
        return [self.topicArr count];
}

@end
