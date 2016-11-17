//
//  TopicListViewController.h
//  V2EX
//
//  Created by wayne on 2016/11/15.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
- (instancetype)initWithDict:(NSDictionary *)dict VC:(UIViewController *)vc;
@end
