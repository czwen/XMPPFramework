//
//  ChatViewController.h
//  iPhoneXMPP
//
//  Created by ChenZhiWen on 7/16/14.
//
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "iPhoneXMPPAppDelegate.h"
@interface ChatViewController : UIViewController<XMPPStreamDelegate,UITextFieldDelegate>

- (void)setChatForUser:(XMPPUserCoreDataStorageObject*)user;


@end
