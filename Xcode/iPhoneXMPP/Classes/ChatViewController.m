//
//  ChatViewController.m
//  iPhoneXMPP
//
//  Created by ChenZhiWen on 7/16/14.
//
//

#import "ChatViewController.h"

@interface ChatViewController ()
@property (nonatomic,strong) XMPPUserCoreDataStorageObject *user;
@property (weak, nonatomic) IBOutlet UITextView *chatView;
@property (weak, nonatomic) IBOutlet UITextField *myInputView;
@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setChatForUser:(XMPPUserCoreDataStorageObject*)user
{
    self.user = user;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myInputView.delegate = self;
    [[[self appDelegate]xmppStream]addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[[self appDelegate]xmppStream]removeDelegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.myInputView) {
        [textField resignFirstResponder];
        [self sendMessage:textField.text];
        textField.text = @"";
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendMessage:(NSString*)messages
{
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:messages];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = [NSString stringWithFormat:@"%@", self.user.jidStr];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addChild:body];
    
    [[[self appDelegate]xmppStream]sendElement:message];
}

- (iPhoneXMPPAppDelegate *)appDelegate
{
	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    self.chatView.text = [[self.chatView.text stringByAppendingString:message.stringValue]stringByAppendingString:@"\n" ];
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    self.chatView.text = [[self.chatView.text stringByAppendingString:message.stringValue]stringByAppendingString:@"\n" ];
}
@end
