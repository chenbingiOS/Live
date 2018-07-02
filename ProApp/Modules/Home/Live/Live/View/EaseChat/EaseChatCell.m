//
//  EaseChatCell.m
//  UCloudMediaRecorderDemo
//
//  Created by EaseMob on 16/6/12.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import "EaseChatCell.h"

@interface EaseChatCell ()

@end

@implementation EaseChatCell


- (void)setMesssage:(EMMessage*)message
{
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.shadowColor = [UIColor blackColor];
    self.textLabel.shadowOffset = CGSizeMake(1, 1);
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.attributedText = [EaseChatCell _attributedStringWithMessage:message];
    self.textLabel.numberOfLines = (int)([EaseChatCell heightForMessage:message]/15.f) + 1;
    NSLog(@"%@", @(self.textLabel.numberOfLines));
}

+ (CGFloat)heightForMessage:(EMMessage *)message
{
    if (message) {
        CGRect rect = [[EaseChatCell _attributedStringWithMessage:message] boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        if (rect.size.height < 25.f) {
            return 25.f;
        }
        return rect.size.height;
    }
    return 25.f;
}

// 2. 由图片生成attributedString
+ (NSAttributedString *)attributedStringWithImage:(UIImage *)image imageBounds:(CGRect)bounds {
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    NSAttributedString *attachmentAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    return attachmentAttributedString;
}

+ (NSMutableAttributedString*)_attributedStringWithMessage:(EMMessage*)message
{
    NSString *text = [EaseChatCell latestMessageTitleForConversationModel:message];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paraStyle,NSFontAttributeName :[UIFont systemFontOfSize:15.0f]};
    [string addAttributes:attributes range:NSMakeRange(0, string.length)];
    NSDictionary *userExt = message.ext;
    if (userExt[@"userName"]) {
        NSRange range = [text rangeOfString:[NSString stringWithFormat:@"%@: " , userExt[@"userName"]] options:NSCaseInsensitiveSearch];
        UIColor *color = [UIColor mainColor];
        [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, range.length)];
    } else {
        if ([message.from isEqualToString:[EMClient sharedClient].currentUsername]) {
            NSRange range = [text rangeOfString:[NSString stringWithFormat:@"%@: " ,[EMClient sharedClient].currentUsername] options:NSCaseInsensitiveSearch];
            UIColor *color = [UIColor mainColor];
            [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, range.length)];
        }
    }
    NSString *userLevel = userExt[@"userLevel"];
    NSString *imgName = [NSString stringWithFormat:@"v%@", userLevel];
    NSAttributedString *imageAttributedString = [EaseChatCell attributedStringWithImage:[UIImage imageNamed:imgName] imageBounds:CGRectMake(0, -6, 38, 21)];
    NSAttributedString *resultAttributedString = [EaseChatCell jointAttributedStringWithItems:@[string]];

    return resultAttributedString.mutableCopy;
}

+ (NSAttributedString *)jointAttributedStringWithItems:(NSArray *)items {
    NSMutableAttributedString *resultAttributedString = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < items.count; i++) {
        if ([items[i] isKindOfClass:[NSAttributedString class]]) {
            [resultAttributedString appendAttributedString:items[i]];
        }
    }
    return resultAttributedString;
}

+ (NSString *)latestMessageTitleForConversationModel:(EMMessage*)lastMessage {
    NSString *latestMessageTitle = @"";
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"[图片]";
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = @"[语音]";
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = @"[位置]";
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = @"[视频]";
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = @"[文件]";
            } break;
            default: {
            } break;
        }
    }
    
    if (lastMessage.ext) {
        NSDictionary *userExt = lastMessage.ext;
        if (userExt[@"userNickName"]) {
            latestMessageTitle = [NSString stringWithFormat:@" %@: %@",userExt[@"userNickName"], latestMessageTitle];
        }
    } else {
        latestMessageTitle = [NSString stringWithFormat:@" %@: %@",lastMessage.from,latestMessageTitle];
    }
    return latestMessageTitle;
}

@end
