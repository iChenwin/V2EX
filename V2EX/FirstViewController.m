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

@interface FirstViewController ()
@property (strong, nonatomic) NSMutableArray *topicArr;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *keywords = @[@"mbp", @"macbookpro", @"macbook pro"];
    self.topicArr = [[NSMutableArray alloc] initWithArray:[self topicArrInNode:@"all4all" withKeywordArr:keywords andNumberOfTopics:30]];
    
}

-(void)viewWillAppear:(BOOL)animated {
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
        NSDictionary *dict = self.topicArr[indexPath.row];
//        cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.topicArr[indexPath.row][@"title"]];
        cell.titleLabel.text = dict[@"title"];
//        double timeStamp = [self.topicArr[indexPath.row][@"created"] doubleValue];
//        NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
//        //用于格式化NSDate对象
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        //设置格式：zzz表示时区
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        //NSDate转NSString
//        NSString *timeString = [dateFormatter stringFromDate:createdDate];
//        cell.timeLabel.text = timeString;
        
        cell.timeLabel.text = dict[@"time"];
        
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopicCell:)];
//        cell.tag = [self.topicArr[indexPath.row][@"id"] integerValue];
        cell.tag = [dict[@"topicID"] integerValue];
        [cell addGestureRecognizer:tapCell];
    }
    
    return cell;
}

- (void)tapTopicCell:(UITapGestureRecognizer *)sender {
    WebViewController *webVC = [[WebViewController alloc] initWithURLString:[NSString stringWithFormat:@"https://www.v2ex.com/t/%ld", sender.view.tag] andVC:self];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    __block NSArray *response;
    
//    [manager GET:@"https://www.v2ex.com/api/topics/show.json?node_name=all4all" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        response = [[NSMutableArray alloc] initWithArray:responseObject];
//        dispatch_semaphore_signal(semaphore);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        dispatch_semaphore_signal(semaphore);
//    }];
    
    
    
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    self.topicArr = [[NSMutableArray alloc] initWithArray:response];
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

- (NSDictionary *)topicDictFromElementStr:(NSString *)elementStr {
    NSMutableDictionary *topicsDict = [NSMutableDictionary dictionary];
    NSMutableString *divString = [[NSMutableString alloc] initWithString:elementStr];
    //话题ID
    NSRange range = [divString rangeOfString:@" t_"];
    [divString deleteCharactersInRange:NSMakeRange(0, range.location + range.length)];
    NSInteger topicID = [[divString substringWithRange:NSMakeRange(0, 6)] integerValue];
    [topicsDict  setValue:[NSNumber numberWithInteger:topicID] forKey:@"topicID"];
    //话题标题
    range = [divString rangeOfString:@"<span class=\"item_title\"><a href=\"/t/"];
    [divString deleteCharactersInRange:NSMakeRange(0, range.location + range.length)];
    range = [divString rangeOfString:@"\">"];
    [divString deleteCharactersInRange:NSMakeRange(0, range.location + range.length)];
    range = [divString rangeOfString:@"</a></span>"];
    NSString *title = [divString substringWithRange:NSMakeRange(0, range.location)];
    [topicsDict setObject:title forKey:@"title"];
    //话题最后回复时间
    range = [divString rangeOfString:@"  •  "];
    [divString deleteCharactersInRange:NSMakeRange(0, range.length + range.location)];
    range = [divString rangeOfString:@"  •  "];
    if (NSNotFound == range.location) {
        range = [divString rangeOfString:@"</span>"];
    }
    NSString *timeStr = [divString substringWithRange:NSMakeRange(0, range.location)];
    [topicsDict setObject:timeStr forKey:@"time"];
    
    return topicsDict;
}
- (NSMutableArray *)topicArrFromURLString:(NSString *)urlString withKeywordArr:(NSArray *)keywordArr {
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *dataArr = [xpathParser searchWithXPathQuery:@"/html/body/div/div/div/div/div/div"];
    
    NSMutableArray *topicArr = [NSMutableArray array];
    for (TFHppleElement *hppleElement in dataArr) {
        //        NSLog(@"%@", hppleElement.raw);
        for (int i = 0; i < [keywordArr count]; i++) {
            //获取主题div
            if (NSNotFound != [hppleElement.raw rangeOfString:@"<div class=\"cell from_"].location && NSNotFound != [hppleElement.raw rangeOfString:keywordArr[i] options:NSCaseInsensitiveSearch].location) {
                NSDictionary *dict = [self topicDictFromElementStr:hppleElement.raw];
                [topicArr addObject:dict];
            }
        }
    }
    //返回话题词典组成的数组
    return topicArr;
}
- (NSArray *)topicArrInNode:(NSString *)nodeName withKeywordArr:(NSArray *)keywordArr andNumberOfTopics:(NSInteger)numOfTopics{
    //第一页
    NSString *nodeURLString = [[NSString alloc] initWithFormat:@"https://www.v2ex.com/go/%@", nodeName];
    NSMutableArray *topicArr = [self topicArrFromURLString:nodeURLString withKeywordArr:keywordArr];
    //翻页，2、3、4...页
    for(int i = 2; [topicArr count] < (NSUInteger)numOfTopics; i++){
        NSString *urlString = [nodeURLString stringByAppendingFormat:@"?p=%d", i];
        NSArray *tempArr = [self topicArrFromURLString:urlString withKeywordArr:keywordArr];
        [topicArr addObjectsFromArray:tempArr];
    }
    
    return topicArr;
}

@end
