//
//  MyFunc.h
//  
//
//  Created by wayne on 2016/11/15.
//
//

#import <Foundation/Foundation.h>

@interface MyFunc : NSObject
+ (NSDictionary *)topicDictFromElementStr:(NSString *)elementStr;
+ (NSMutableArray *)topicArrFromURLString:(NSString *)urlString withKeywordArr:(NSArray *)keywordArr;
+ (NSArray *)topicArrInNode:(NSString *)nodeName withKeywordArr:(NSArray *)keywordArr andNumberOfTopics:(NSInteger)numOfTopics;
@end
