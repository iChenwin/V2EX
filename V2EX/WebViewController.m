//
//  WebViewController.m
//  V2EX
//
//  Created by wayne on 2016/11/8.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import "WebViewController.h"
#import "TFHpple.h"

@interface WebViewController ()
@property (strong, nonatomic)UIViewController *fatherVC;
@end

@implementation WebViewController

- (instancetype)initWithURLString:(NSString *) urlStr andVC:(UIViewController *)VC{
    if (self = [super init]) {
        self.urlStr = urlStr;
        self.fatherVC = VC;
        self.webView = [[UIWebView alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    UISwipeGestureRecognizer *swipeleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionRight;
    [self.webView addGestureRecognizer:swipeleft];
    
    [self.webView setDataDetectorTypes:UIDataDetectorTypeLink];
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer  {
    if ([self.webView canGoBack] && gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        [self.webView goBack];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"不能再后退了" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * action) {}];
//        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:^{
                
            }];
        });
    }
}

-(void)back:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.fatherVC.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
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
