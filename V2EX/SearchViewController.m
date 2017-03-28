//
//  SearchViewController.m
//  V2EX
//
//  Created by wayne on 2016/11/15.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import "SearchViewController.h"
#import "TopicListViewController.h"
#import "Macro.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nodeName;
@property (weak, nonatomic) IBOutlet UITextField *keywords;
@property (weak, nonatomic) IBOutlet UITextField *countOfTopic;
@property (strong, nonatomic) UIViewController *fatherVC;
@property (weak, nonatomic) IBOutlet UIButton *searchBnt;
@end

@implementation SearchViewController

- (instancetype)initWithVC:(UIViewController *)vc {
    if (self = [super init]) {
        self.fatherVC = vc;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.fatherVC.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nodeName.layer.borderColor = [UIColor colorWithRed:0 green:128/255.0 blue:1.0 alpha:1.0].CGColor;
    self.keywords.layer.borderColor = [UIColor colorWithRed:0 green:128/255.0 blue:1.0 alpha:1.0].CGColor;
    self.countOfTopic.layer.borderColor = [UIColor colorWithRed:0 green:128/255.0 blue:1.0 alpha:1.0].CGColor;
    
    self.searchBnt.layer.borderWidth = 1;
    self.searchBnt.layer.cornerRadius = 4;
    self.searchBnt.layer.borderColor = [UIColor colorWithRed:0 green:128/255.0 blue:1.0 alpha:1.0].CGColor;
    
    NSUserDefaults *userDefaults = USER_DEFAULT;
    NSDictionary *dict = [userDefaults dictionaryForKey:@"searchDict"];
    
    if (nil != dict) {
        self.nodeName.text = dict[@"nodeName"];
        self.keywords.text = dict[@"keywords"];
        self.countOfTopic.text = dict[@"count"];
    }
    
    self.nodeName.delegate = self;
    self.keywords.delegate = self;
    self.countOfTopic.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)search:(id)sender {
    NSUserDefaults *userDefaults = USER_DEFAULT;
    NSDictionary *dict = [NSDictionary dictionary];
    NSMutableArray *keywordsArr = [NSMutableArray array];
    NSRange range = [self.keywords.text rangeOfString:@","];
    if (NSNotFound != range.location) {
        NSMutableString *string = [NSMutableString stringWithString:self.keywords.text];
        while(NSNotFound != range.location) {
            [keywordsArr addObject:[string substringWithRange:NSMakeRange(0, range.location)]];
            [string deleteCharactersInRange:NSMakeRange(0, range.location + 1)];
            range = [string rangeOfString:@","];
        }
        if (0 != [string length]) {
            [keywordsArr addObject:string];
        }
    } else {
        [keywordsArr addObject:self.keywords.text];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.nodeName.text, @"nodeName", keywordsArr, @"keywords", self.countOfTopic.text, @"count", nil];
        
    [userDefaults setObject:[[NSDictionary alloc] initWithObjectsAndKeys:self.nodeName.text, @"nodeName", self.keywords.text, @"keywords", self.countOfTopic.text, @"count", nil] forKey:@"searchDict"];

    TopicListViewController *topicTableVC = [[TopicListViewController alloc] initWithDict:dict VC:self];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:topicTableVC animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField selectAll:self];
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
