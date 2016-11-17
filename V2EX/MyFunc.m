//
//  MyFunc.m
//  
//
//  Created by wayne on 2016/11/15.
//
//
#import "TFHpple.h"
#import "MyFunc.h"

@implementation MyFunc
+ (NSDictionary *)topicDictFromElementStr:(NSString *)elementStr {
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
+ (NSMutableArray *)topicArrFromURLString:(NSString *)urlString withKeywordArr:(NSArray *)keywordArr {
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
+ (NSArray *)topicArrInNode:(NSString *)nodeName withKeywordArr:(NSArray *)keywordArr andNumberOfTopics:(NSInteger)numOfTopics{
    //第一页
    NSString *nodeURLString = [[NSString alloc] initWithFormat:@"https://www.v2ex.com/go/%@", nodeName];
    NSMutableArray *topicArr = [self topicArrFromURLString:nodeURLString withKeywordArr:keywordArr];
    //翻页，2、3、4...页
    for(int i = 2; [topicArr count] < (NSUInteger)numOfTopics; i++){
        NSString *urlString = [nodeURLString stringByAppendingFormat:@"?p=%d", i];
        NSArray *tempArr = [self topicArrFromURLString:urlString withKeywordArr:keywordArr];
        [topicArr addObjectsFromArray:tempArr];
        
        if(5 == i && 0 == [topicArr count]) {
            break;
        }
    }
    
    return topicArr;
}
@end
