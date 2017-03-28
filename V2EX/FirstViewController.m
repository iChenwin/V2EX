//
//  FirstViewController.m
//  V2EX
//
//  Created by wayne on 16/10/17.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import "FirstViewController.h"
#import "AFNetworking.h"
#import "TopicTableViewCell.h"
#import "WebViewController.h"
#import "TFHpple.h"
#import "SearchViewController.h"

@interface FirstViewController ()
@property (strong, nonatomic) NSMutableArray *topicArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.topicArr = [NSMutableArray array];
//    NSArray *keywords = @[@"5s"] ;//]@"mbp", @"macbookpro", @"macbook pro"];
//    self.topicArr = [[NSMutableArray alloc] initWithArray:[self topicArrInNode:@"iphone" withKeywordArr:keywords andNumberOfTopics:30]];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.hidesBottomBarWhenPushed = NO;
//    self.navigationController.navigationBar.hidden = YES;
    [self.tableView reloadData];
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
        cell.tag = [self.topicArr[indexPath.row][@"id"] integerValue];
        
//        NSDictionary *dict = self.topicArr[indexPath.row];
//        cell.titleLabel.text = dict[@"title"];
//        cell.timeLabel.text = dict[@"time"];
//        cell.tag = [dict[@"topicID"] integerValue];
        
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopicCell:)];

        
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
    
    [manager GET:@"https://www.v2ex.com/api/topics/hot.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        response = [[NSMutableArray alloc] initWithArray:responseObject];
        dispatch_semaphore_signal(semaphore);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    self.topicArr = [[NSMutableArray alloc] initWithArray:response];
    
//    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.ichenwinv.v2ex", NULL);
//    dispatch_async(backgroundQueue, ^{
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        __block NSArray *response;
//        [manager GET:@"https://www.v2ex.com/api/topics/hot.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            response = [[NSMutableArray alloc] initWithArray:responseObject];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
//        self.topicArr = (NSMutableArray *)response;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//    });
    
//    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
//    for (NSDictionary *dict in self.topicArr) {
//        if ([dict[@"title"] rangeOfString:@"macbook" options:NSCaseInsensitiveSearch].location != NSNotFound || [dict[@"title"] rangeOfString:@"mbp" options:NSCaseInsensitiveSearch].location != NSNotFound || [dict[@"title"] rangeOfString:@"mac book" options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            [tempArr addObject:dict];
//        }
//    }
//    self.topicArr = tempArr;
    
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

- (IBAction)searchAction:(id)sender {
    SearchViewController *vc = [[SearchViewController alloc] initWithVC:self];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
