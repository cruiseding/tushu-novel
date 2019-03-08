//
//  URLMacros.h
//  Novel
//
//  Created by xth on 2018/1/11.
//  Copyright © 2018年 th. All rights reserved.
//

#ifndef URLMacros_h
#define URLMacros_h

/* ---------------------------------------- 服务器地址  --------------------------------------------- */

#define SERVERCE_HOST @"http://api.zhuishushenqi.com"  //主要host

#define chapter_URL @"http://chapter2.zhuishushenqi.com" //章节内容

#define statics_URL @"http://statics.zhuishushenqi.com"  //静态资源

#define switch_URL @"http://47.106.115.228:8888/on"; //内容页面请求的URL


/* ---------------------------------------- 首页相关  --------------------------------------------- */

//检查书架更新
#define URL_bookShelf_update @"/book"

//获取所有榜单
#define URL_ranking_gender @"/ranking/gender"

//排行榜
#define URL_ranking(id) [NSString stringWithFormat:@"/ranking/%@", id]

//推荐书籍
#define URL_recommend(id) [NSString stringWithFormat:@"/book/%@/recommend", id]

#define URL_search(content) [NSString stringWithFormat:@"/book/fuzzy-search?query=%@&start=0&limit=10000", [NSString encodeToPercentEscapeString:content]]

//书籍详情
#define URL_bookDetail(id) [NSString stringWithFormat:@"/book/%@", id]

//源数组
#define URL_summary(id) [NSString stringWithFormat:@"/toc?view=summary&book=%@", id]

//目录
#define URL_chapters(id) [NSString stringWithFormat:@"/toc/%@?view=chapters", id]

//请求小说内容
#define URL_bookContent(link) [NSString stringWithFormat:@"/chapter/%@", [NSString encodeToPercentEscapeString:link]]

#endif /* URLMacros_h */
