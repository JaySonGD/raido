//
//  TTZData.m
//  WebPlayer
//
//  Created by czljcb on 2018/4/1.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZData.h"
#import "YPNetService.h"

@implementation TTZData

+ (NSDictionary *)loadDataFinish: (void(^)(NSDictionary *))block{
    
    
    if(![YPNetService hasSetProxy]) {
        
        NSURL * url = [NSURL URLWithString:@"http://127.0.0.1/hkradio.json"//@"https://tv-1252820456.cos.ap-guangzhou.myqcloud.com/hkradio%20(1)%20.json"
                       ];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error) return ;
                NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if (obj) {
                    !(block)? : block(obj);
                    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"hkradio"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            });
            
            
        }];
        //开启网络任务
        [task resume];
    }
    
    NSDictionary *obj =  [[NSUserDefaults standardUserDefaults] objectForKey:@"hkradio0"];
    
    
    return obj? obj : [self codeDict];
}


+ (NSDictionary *)codeDict{
    return @{
             @"banner":
                 @[
                     @{
                         @"icon": @"http://m.tvbyb.com/upload/vod/2018-03-01/201803011519886995.jpg",
                         @"name": @"果栏中的江湖大嫂 粤语版",
                         @"url": @"http://acm.gg/jade.m3u8",
                         @"type": @""
                         },
                     @{
                         @"icon": @"http://m.tvbyb.com/upload/vod/2018-03-01/201803011519886943.jpg",
                         @"name": @"翻生武林 粤语版",
                         @"url": @"http://m.yueyuwz.com/ffhd/ffyy194444.html",
                         @"type": @""
                         }
                     
                     ],
             @"list":
                 @[
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-be87b1780aea777a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"香港第一台",
                         @"main":@"第一新闻及资讯频道",

                         @"type": @"radio",
                         @"des":@"以粤语广播，传递最新最全面新闻时事资讯，兼备交流空间，让民意和政府政策得以互相传达，协助公民社会的发展。",
                         @"url":@"http://rthkaudio1-lh.akamaihd.net/i/radio1_1@355864/master.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-be87b1780aea777a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"香港第二台",
                         @"main":@"第二家庭频道，着重青年、社区活动及音乐频道",
                         @"des":@"以粤语广播，提供多样化的生活资讯，推动社会共融，鼓励包容小众社群，支持多元文化发展。同时开拓与年青人沟通的网上世界，设有年青人网上电台Teen Power。",
                         @"type": @"radio",
                         @"url":@"http://rthkaudio2-lh.akamaihd.net/i/radio2_1@355865/master.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-be87b1780aea777a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"香港第三台",
                         @"main":@"第三英语新闻及资讯频道",
                         @"type": @"radio",
                         @"des":@"以英语广播，为居港的英语人士提供各方资讯，协助他们投入本地社会事务，融入香港。",
                         @"url":@"http://rthkaudio3-lh.akamaihd.net/i/radio3_1@355866/master.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-be87b1780aea777a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"香港第四台",
                         @"main":@"第四香港唯一的古典音乐频道",
                         @"type": @"radio",
                         @"des":@"以(英语/粤语)双语广播，藉推广美乐(Fine Music)提升大众精神生活的素质，是唯一的古典音乐频道。",

                         @"url":@"http://rthkaudio4-lh.akamaihd.net/i/radio4_1@355867/master.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-be87b1780aea777a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"香港第五台",
                         @"main":@"第五长者、文化及教育频道",
                         @"type": @"radio",
                         @"des":@"以粤语广播，既服务长者又照顾小众，全力做到“戏曲文教．生活传真．敬老慈幼．服务社群”。",

                         @"url":@"http://rthkaudio5-lh.akamaihd.net/i/radio5_1@355868/master.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-be87b1780aea777a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"无线新闻台",
                         @"main":@"TVB免费数码频道83台互动新闻台",
                         @"type": @"radio",
                         @"des":@"播放内容包括本地及国际新闻大事、新闻回顾、财经资讯、专题特辑等。无线新闻部在北京及广州等地设有新闻中心，而新闻报导中包括“中华掠影”等资讯时段。",
                         @"url":@"http://lhttp.qingting.fm/live/1265/64k.mp3"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-37ebf7e7ff6aa6d1.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"港台RTHK31",
                         @"des":@"香港电台的“综合频道”，会播放时事、教育、资讯、文化及艺术和戏剧节目，内容包括全新制作节目、外购节目、本台精选、经典重温、教育电视、天气及视象直播香港电台第一台之星期一至六早上8时至9时的节目，并加入电视新闻《新闻天地》及早晨资讯节目《早辰。早晨》等等，务求将港台节目变得多元化。",
                         @"type": @"radio",
                         @"main":@"香港电台拥有的一条免费数字电视频道",
                         @"url":@"http://d2agljdoug3z0j.cloudfront.net/radio-HTTP/cr2-hd.3gp/playlist.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-37ebf7e7ff6aa6d1.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"港台RTHK32",
                         @"type": @"radio",
                         @"main":@"香港电台拥有的一条播映中的电视频道，为免费电视频道中唯一的直播资讯频道",
                         @"des":@"该频道定为香港电台的“直播频道”，以直播立法会会议及其他重要记者会为主。",
                         @"url":@"http://rthkaudio5-lh.akamaihd.net/i/radio5_1@355868/master.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-44eb1964fd2c3310.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"香港 Satellite",
                         @"url":@"http://103.11.102.62:8000/talkonly.mp3"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-be87b1780aea777a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"TVB Station",
                         @"type": @"radio",

                         @"url":@"http://live4.tdm.com.mo/radio/rch2.live/playlist.m3u8"
                         },
//                     @{
//                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-1b0b9e01c59db2d1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
//                         @"name":@"香港第五台",
//                         @"type": @"radio",
//
//                         @"url":@"http://rthkaudio5-lh.akamaihd.net/i/radio5_1@355868/master.m3u8"
//                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-4aeda4a538c45f0c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"香港第七台",
                         @"main":@"第七香港唯一的普通话频道",
                         @"type": @"radio",
                         @"des":@"本港普通话广播频道，与凤凰卫视旗下的凤凰优悦广播(凤凰U-radio)共同肩负著推广普通话应用，以及促进世界华语地区讯息交流的使命。",

                         @"url":@"http://rthkaudio6-lh.akamaihd.net/i/radiopth_1@355869/master.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-b31ca9d0178f441c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"香港FM 88.1MHZ",
                         @"type": @"radio",

                         @"url":@"http://d2agljdoug3z0j.cloudfront.net/radio-HTTP/cr1-hd.3gp/playlist.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-592260a0867523f9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"香港FM 90.3MHZ",
                         @"type": @"radio",

                         @"url":@"http://d2agljdoug3z0j.cloudfront.net/radio-HTTP/cr2-hd.3gp/playlist.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-0ceebd08a39bd451.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"新城财经台",
                         @"type": @"radio",
                         @"des":@"新城财经台以粤语广播，主要报道香港及外地的股汇行情，以及少量音乐与资讯节目。该台口号为“全球财经，尽在新城”。",
                         @"url":@"http://metroradio-lh.akamaihd.net/i/997_h@349799/master.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-85df1cce91358ae2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"新城资讯台",
                         @"type": @"radio",
                         @"des":@"新城知讯台以粤语广播，以资讯、娱乐和音乐为主，部份时间联播新城财经台和广东电台的节目，定位较为不清晰。该台口号为“知讯音乐 成就力量”。",
                         @"url":@"http://metroradio-lh.akamaihd.net/i/104_h@349798/master.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-39f776fab9ea19af.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"Metro Plus",
                         @"type": @"radio",

                         @"url":@"http://metroradio-lh.akamaihd.net/i/1044_h@349800/master.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-86c28d2268cf81eb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"D100 PBS",
                         @"type": @"radio",

                         @"url":@"http://59.152.232.108:8000/Channel1-128AAC"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-57174233de246bcc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"澳门电台",
                         @"type": @"radio",

                         @"url":@"http://live4.tdm.com.mo/radio/rch2.live/playlist.m3u8"
                         },
                     @{
                         @"icon":@"https://upload-images.jianshu.io/upload_images/1274527-0d4b73e87c0bf0f4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                         @"name":@"Station",
                         @"type": @"radio",

                         @"url":@"http://rfahls-i.akamaihd.net/hls/live/226232/RFALive_1/index.m3u8"
                         },
                     @{
                         @"name": @"广东电台音乐之声",
                         @"url": @"http://ctt.rgd.com.cn/fm993",
                         @"type": @"radio",
                         @"des" : @"广东电台音乐之声是一个高品味、全方位的专业音乐电台，其节目在突出欣赏性、娱乐性的同时，兼具新闻、体育、社会生活等各类资讯。",
                         @"icon": @"http://image.tinberfm.com//uploadnew/330441493113025.jpg",
                         },
                     @{
                         @"name": @"中山电台快乐 888",
                         @"type": @"radio",
                         @"des" : @"有我，更快乐！",
                         @"url": @"http://pili-live-hls.qiniu.tinberfm.com/live-yuanyu/zsradio.m3u8",
                         @"icon": @"http://image.tinberfm.com//uploadnew/763161467048963.jpg",
                         },
                     @{
                         @"name": @"怀集音乐之声",
                         @"type": @"radio",
                         @"des" : @"怀集音乐之声是一个旨在服务怀集,宣传怀集,建设怀集为宗旨.为广大为事业打拼而于珠三角的怀集乡贤乡里提供一个相互交流的平台!!! 让每一位乡里无论处世界任何一个角落都能感受到一种家乡的感觉!!同时以音乐为你生活喝彩的主题并致力打造一个非一般的听觉空间.一直以来深受各地听众喜爱!!!",
                         @"url": @"http://live.xmcdn.com/live/1205/64.m3u8",
                         @"icon": @"http://image.tinberfm.com//uploadnew/421591471596839.jpg",
                         },
                     @{
                         @"name": @"深圳飞扬音乐",
                         @"type": @"radio",
                         @"des" : @"全天24小時不間斷播出，秉承”飛揚971，神州樂逍遙”的節目理念，做南中國最歡樂的音樂廣播。",
                         @"url": @"http://lhttp.qingting.fm/live/1271/64k.mp3",
                         @"icon": @"http://image.tinberfm.com//uploadnew/610861471675417.jpg",
                         },
                     @{
                         @"name": @"广东股市广播",
                         @"type": @"radio",
                         @"des":@"华南地区收听率第一的财经资讯电台。实时直击股票、期货、外汇、黄金交易行情。二十载，与全国投资者共同成长。",
                         @"url": @"http://lhttp.qingting.fm/live/4847/64k.mp3",
                         @"icon": @"http://image.tinberfm.com//uploadnew/549361471675673.jpg",
                         },
                     @{
                         @"name": @"深圳先锋",
                         @"type": @"radio",
                         @"des":@"先锋898,以“新闻先锋、财经先锋、体育先锋、生活先锋”为立台宗旨,全天24小时新闻构架,凸显“深圳声音”和“深圳速度”。",
                         @"url": @"http://lhttp.qingting.fm/live/1270/64k.mp3",
                         @"icon": @"http://image.tinberfm.com//uploadnew/354881471595955.jpg",
                         },
                     @{
                         @"name": @"佛山电台真爱",
                         @"type": @"radio",
                         @"des" :@"是以新闻和资讯服务为主要内容的频率。",
                         @"url": @"http://lhttp.qingting.fm/live/1265/64k.mp3",
                         @"icon": @"http://image.tinberfm.com//uploadnew/201391470133516.jpg",
                         },
                     @{
                         @"name": @"深圳交通广播",
                         @"type": @"radio",
                         @"des" : @"深圳交通文宣、交通資訊、交通資訊為主要節目內容，利用現代化交通監控、資訊傳播手段，為强化都市交通管理，增强市民交通法規意識服務",
                         @"url": @"http://lhttp.qingting.fm/live/1272/64k.mp3",
                         @"icon": @"http://image.tinberfm.com//uploadnew/912891471590808.jpg",
                         },
                     @{
                         @"name": @"新会人民广播电台",
                         @"type": @"radio",
                         @"des" : @"这里是新会人民广播电台。",
                         @"url": @"http://lhttp.qingting.fm/live/5061/64k.mp3",
                         @"icon": @"http://image.tinberfm.com//uploadnew/472231487051576.jpg",
                         },
                     @{
                         @"name": @"郁南音乐台",
                         @"type": @"radio",
                         @"des": @"这里是郁南音乐台。欢迎大家收听！",
                         @"url": @"http://pili-live-hls.qiniu.tinberfm.com/live-yuanyu/ynyyt.m3u8",
                         @"icon": @"http://image.tinberfm.com//uploadnew/879531478146553.jpg",
                         },
                     @{
                         @"name": @"鹤山电台",
                         @"type": @"radio",
                         @"des" : @"暂无专辑详情",
                         @"url": @"http://lhttp.qingting.fm/live/1286/64k.mp3",
                         @"icon": @"http://image.tinberfm.com//uploadnew/333991471674235.jpg",
                         },
                     @{
                         @"name": @"中山电台新锐 967",
                         @"type": @"radio",
                         @"des" : @"天下资讯，百姓民生”，新锐967是以新闻、资讯为主打，致力于打造亲民、便民、帮民的新闻资讯频率。",
                         @"url": @"http://pili-live-hls.qiniu.tinberfm.com/live-yuanyu/zsdtxr967.m3u8",
                         @"icon": @"http://image.tinberfm.com//uploadnew/275731469672180.jpg",
                         },
                     @{
                         @"name": @"广州花都广播",
                         @"type": @"radio",
                         @"des" : @"花都电台自1985年8月15日开播，于2008年12月22日绚丽绽放“花开的声音”。我们坚持“节目立台，服务为本”，坚守比满分多一点的承诺，为花都人民服务。",
                         @"url": @"http://pili-live-hls.qiniu.tinberfm.com/live-yuanyu/gzhdgb.m3u8",
                         @"icon": @"http://image.tinberfm.com//uploadnew/657081493114007.jpg",
                         },
                     @{
                         @"name": @"珠海电台活力",
                         @"type": @"radio",
                         @"des" : @"珠海电台FM91.5汽车音乐广播，好音乐，在路上；活力915，音乐就要我！ 合作联系：0756-3325722，微信公众号请搜索：珠海电台活力915",
                         @"url": @"http://lhttp.qingting.fm/live/5021725/64k.mp3",
                         @"icon": @"http://image.tinberfm.com//uploadnew/639991471597364.jpg",
                         },
                     @{
                         @"name": @"梅州私家车广播",
                         @"type": @"radio",
                         @"des" : @"暂无专辑详情",
                         @"url": @"http://lhttp.qingting.fm/live/5021942/64k.mp3",
                         @"icon": @"http://image.tinberfm.com//uploadnew/728671471675934.jpg",
                         },
                     @{
                         @"name": @"深圳龙岗电台星光",
                         @"type": @"radio",
                         @"des" : @"暂无专辑详情",
                         @"url": @"http://live.xmcdn.com/live/266/64.m3u8",
                         @"icon": @"http://image.tinberfm.com//uploadnew/601621471674823.jpg",
                         },
                     @{
                         @"name": @"从化流溪河之声",
                         @"type": @"radio",
                         @"des" : @"暂无专辑详情",
                         @"url": @"http://lhttp.qingting.fm/live/15318698/64k.mp3",
                         @"icon": @"http://image.tinberfm.com//uploadnew/264851472128108.jpg",
                         },
                     @{
                         @"name": @"韶关交通旅游广播",
                         @"type": @"radio",
                         @"des" : @"暂无专辑详情",
                         @"url": @"http://lhttp.qingting.fm/live/5022075/64k.mp3",
                         @"icon": @"http://image.tinberfm.com//uploadnew/989151472117651.jpg",
                         },
                     @{
                         @"name": @"广西文艺广播 Music Radio",
                         @"type": @"radio",
                         @"des":@"广西文艺广播FM95.0是广西唯一一家规模最大，以播出音乐、娱乐节目为主要内容的省级专业文艺电台，标语——“就是爱音乐”！",
                         @"url": @"http://media2.bbrtv.com:1935/live/_definst_/950/playlist.m3u8",
                         @"icon": @"http://image.tinberfm.com//uploadnew/636171467048922.jpg",
                         },
                     @{
                         @"name": @"广西 970 女主播电台",
                         @"type": @"radio",
                         @"des":  @"970女主播电台在FIFM电台世界收听率排名第十三位。CSM央视索福瑞数据调查，以半小时为节目单元进入南宁地区所有电台前三名总数，970女主播电台连续十四个月位居第一！970女主播，听听资讯听听歌！广西第一家概念电台，2015年已连续多周获得收听率第一！",
                         @"url": @"http://media2.bbrtv.com:1935/live/_definst_/970/playlist.m3u8",
                         @"icon": @"http://image.tinberfm.com//uploadnew/710281467048946.jpg",
                         },
                     @{
                         @"name": @"南宁电台经典 1049",
                         @"type": @"radio",
                         @"des": @"经典1049，一路经典一路听。广西南宁上空唯一经典流行音乐电台。",
                         @"url": @"http://lhttp.qingting.fm/live/20769/64k.mp3",
                         @"icon": @"http://image.tinberfm.com//uploadnew/894081472122389.jpg",
                         },
                     @{
                         @"name": @"南宁电台动感895",
                         @"type": @"radio",
                         @"des":@"动感895！音乐嗨翻天！",
                         @"url": @"http://pili-live-hls.qiniu.tinberfm.com/live-yuanyu/nndtdg895.m3u8",
                         @"icon": @"http://image.tinberfm.com//uploadnew/257421492419152.jpg",
                         },
                     @{
                         @"name": @"玉林交通音乐广播",
                         @"type": @"radio",
                         @"des" : @"暂无专辑详情",
                         @"url": @"http://lhttp.qingting.fm/live/1763/64k.mp3",
                         @"icon": @"http://image.tinberfm.com//uploadnew/549421469671182.jpg",
                         },
                     @{
                         @"name": @"贺州电台交通音乐广播",
                         @"type": @"radio",
                         
                         @"des" : @"暂无专辑详情",
                         @"url": @"http://pili-live-hls.qiniu.tinberfm.com/live-yuanyu/hzdtjtylgb.m3u8",
                         @"icon": @"http://image.tinberfm.com//uploadnew/905151469672659.jpg",
                         },
                     @{
                         @"name": @"广西旅游广播",
                         @"type": @"radio",
                         @"des" : @"暂无专辑详情",
                         @"url": @"http://media.bbrtv.com:1935/live/_definst_/lypl/playlist.m3u8",
                         @"icon": @"http://image.tinberfm.com//uploadnew/414361471673293.jpg",
                         },
                     @{
                         @"name": @"贺州电台新闻综合广播",
                         @"type": @"radio",
                         @"des":@"贺州综合广播的发展理念是品味、品质、品牌，直播、互动、共享，使节目进一步贴近实际、贴近生活，贴近听众，为构建和谐贺州营造良好的舆论氛围。",
                         @"url": @"http://pili-live-hls.qiniu.tinberfm.com/live-yuanyu/hzdtxwzhgb.m3u8",
                         @"icon": @"http://image.tinberfm.com//uploadnew/286371470129521.jpg",
                         }
                     
                     ]
             };
}

@end
