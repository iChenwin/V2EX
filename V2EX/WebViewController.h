//
//  WebViewController.h
//  V2EX
//
//  Created by wayne on 2016/11/8.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *urlStr;
- (instancetype)initWithURLString:(NSString *) urlStr andVC:(UIViewController *)VC;
@end
