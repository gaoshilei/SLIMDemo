//
//  SLAnalogDataGenerator.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/2/1.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLAnalogDataGenerator.h"

/**** 测试用 ****/
static NSArray *SLAnalogDataGeneratorIconNamesArray;
static NSArray *SLAnalogDataGeneratorWebImageArray;
static NSArray *SLAnalogDataGeneratorMessagesArray;

@interface SLAnalogDataGenerator()

@end

@implementation SLAnalogDataGenerator

+ (NSString *)randomWebImageUrlString {
    int randomIndex = arc4random_uniform((int)[self webImages].count);
    return SLAnalogDataGeneratorWebImageArray[randomIndex];
}

+ (NSString *)randomIconImageName
{
    int randomIndex = arc4random_uniform((int)[self iconNames].count);
    return SLAnalogDataGeneratorIconNamesArray[randomIndex];
}

+ (NSString *)randomMessage
{
    int randomIndex = arc4random_uniform((int)[self messages].count);
    return SLAnalogDataGeneratorMessagesArray[randomIndex];
}

+ (NSArray *)iconNames
{
    if (!SLAnalogDataGeneratorIconNamesArray) {
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < 29; i++) {
            NSString *iconName = [NSString stringWithFormat:@"%d.jpg", i];
            [temp addObject:iconName];
        }
        SLAnalogDataGeneratorIconNamesArray = [temp copy];
    }
    return SLAnalogDataGeneratorIconNamesArray;
}

+ (NSArray *)webImages {
    if (!SLAnalogDataGeneratorWebImageArray) {
        SLAnalogDataGeneratorWebImageArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517476662388&di=e308f666d6cd6ae708d4314c1609516c&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F503d269759ee3d6db032f61b48166d224e4ade6e.jpg",
                                               @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517476662465&di=0e0136fdf8e5c39dbe8f831b70f8a7d2&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fc8ea15ce36d3d5397966ba5b3187e950342ab0cb.jpg",
                                               @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517476704274&di=892e10e16d9199d33763a35e72d6d327&imgtype=0&src=http%3A%2F%2Fpic29.photophoto.cn%2F20131204%2F0034034499213463_b.jpg",
                                               @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517476704273&di=ab4df44ba8f3363edeed7cf862529801&imgtype=0&src=http%3A%2F%2Fpic4.nipic.com%2F20091121%2F3764872_215617048242_2.jpg",
                                               @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517476704273&di=ebdfd6f0e1cc80d9cdac471c62987f0d&imgtype=0&src=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F140227%2F235111-14022F9410899.jpg",
                                               @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517476704273&di=b9a23d320276881ccfd4fda32c2bcf83&imgtype=0&src=http%3A%2F%2Fpic36.photophoto.cn%2F20150825%2F0034034443021088_b.jpg",
                                               @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517476751910&di=0e235384e22aacbddbe12da41cff8e3f&imgtype=0&src=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F111110%2F1407-11111010303554.jpg",
                                               @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1518071481&di=d06f3e74486e9e372423c143020a70a7&imgtype=jpg&er=1&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F15%2F53%2F43g58PICz9B.jpg"
                                               ];
    }
    return SLAnalogDataGeneratorWebImageArray;
}

+ (NSArray *)messages
{
    if (!SLAnalogDataGeneratorMessagesArray) {
        SLAnalogDataGeneratorMessagesArray = @[@"二龙湖浩哥：什么事？🤪🤪🤪",
                          @"还有几天就放假了啊",
                          @"么么哒哦，啦啦啦啦阿拉啦",
                          @"哎哟我擦嘞！",
                          @"对于程序员而言，可能并不需要像网络管理员一样对计算机网络协议了如指掌，但在进行网络编程时，了解网络协议之间的关系对于方案的选型、架构的设计、代码的实现还是非常必要的。",
                          @"We're so proud to have been named #1 utility tool of the year by StackShare! Even happier to be recognized for the \"small but impactful changes\" we've made to Postman over 2017, all to benefit developers. Thanks to everyone in our community!",
                          @"没吃啊，我在打游戏",
                          @"本次图有两张：一张是全协议关系图，罗列了所有计算机网络协议的关系。另一张是TCP/IP协议关系图（只是全协议关系图的TCP/IP部分），且专门适配了A3打印纸格式，适合打印。本次图有两张：一张是全协议关系图，罗列了所有计算机网络协议的关系。另一张是TCP/IP协议关系图（只是全协议关系图的TCP/IP部分），且专门适配了A3打印纸格式，适合打印。",
                          @"hello world：🤓🤓我不懂",
                          @"大脸猫：这。。。。。。酸爽~ http://www.52im.net/thread-1379-1-1.html",
                          @"你似不似傻：呵呵😜😜😜",
                          @"天天向上：辛苦了！",
                          @"新年快乐！狗年大吉！摸摸哒 http://www.52im.net/thread-180-1-1.html",
                          @"别给我晒脸：坑死我了。。。。。",
                          @"微风：麻蛋！！！",
                          @"北艾路1660弄小区简装出租\n01.物业名称：北艾路1660弄小区\n02.所在区域：北艾路1660弄\n03.楼 层：4楼\n04.楼梯电梯：低层6楼\n05.房   型：单间\n06.房间面积：20\n07.装修情况：精装，家电等全新。\n08.是否隔间：飘窗北卧，非隔间房\n09.基本设施：洗衣机，空调，卫生间、热水器、wifi。\n10.是否独卫：是\n11.空 调：有\n12.网络宽带：有\n13.每月租金：1500-1650\n14.起始租期：随时（下周）\n15.看房时间：随时（周末）\n16.性别要求：无\n17.联系方式：头像\n20.其它信息：附近超市 电影院、星巴克、必胜客、菜市场（200m内），健身房、大型商场、医院（1km以内）",
                          @"夜在哭泣：好好地，🤪别瞎胡闹",
                          @"Minimize extra time spent on marketing and those annoying administrative duties, like countless back-and-forth emails to figure out a time to meet with a client. Make your page work for you with features like Lead Capture and Appointment Scheduling, all included in about.me Pro.",
                          @"法海你不懂爱：春晚太难看啦，妈蛋的🐎🐎🐎🐎🐎🐎🐎🐎",
                          @"长城长：好好好~~~",
                          @"你吃了吗？",
                          @"This certificate will no longer be valid in 30 days. To create a new certificate, visit Certificates, Identifiers & Profiles in your account. Certificate: iOS Distribution\nTeam ID: Shanghai Weming Auto Service Co., Ltd.\nTo learn more about expired certificates, visit the certificates support page.\nBest regards,\nApple Developer Relations",
                          @"派大星：这。。。。。。酸爽~ http://www.52im.net/thread-180-1-1.html",
                          @"原来我不帅：有木有人儿？",
                          @"亲亲我的宝贝：你说啥呢",
                          @"请叫我吴彦祖：好搞笑😤，下次还来",
                          @"服务端性能指标总结：\nRainbowAV服务端基于Linux epoll（大名鼎鼎的Ngnix的高性能正是以此为基础），理论设计性能是：单机1000到10000人同时使用。鉴于实时音视频的复杂性（P2P、中转等混合发生），想要准确地测试统计非常困难。但鉴于实时音视频技术的高流量特性，通常单机瓶颈会首先出现在带宽上，所以生产部署时需要在单机性能和带宽分流上总体考虑。而也正是得益于实时音视频的特殊性，聊天时可同时部署多个服务端实例，只要引导该对聊天的用户同时连接同一台实例即可进行聊天，从而让分布式部署和负载均衡变的简单。",
                          @"帅锅莱昂纳多：我不理解 http://www.52im.net/thread-180-1-1.html",
                          @"星星之火：脱掉，脱掉，统统脱掉",
                          @"雅蠛蝶~雅蠛蝶：好脏，好污，好喜欢"
                          ];
    }
    return SLAnalogDataGeneratorMessagesArray;
}

@end
