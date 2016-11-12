//
//  TopicTableViewCell.h
//  V2EX
//
//  Created by wayne on 2016/11/8.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
