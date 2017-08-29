
#import "ViewController.h"
#import "mianTableViewCell.h"
#import "otherTableViewCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
// 消息的结果集
@property (strong,nonatomic) NSFetchedResultsController * resultsController;
@property (nonatomic,strong)NSMutableArray  *allDataArr;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天室";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    UIView *vi = [UIView new];
    self.tableView.tableFooterView =vi;
    vi.backgroundColor = [UIColor grayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[mianTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[otherTableViewCell class] forCellReuseIdentifier:@"other"];
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.allDataArr = [NSMutableArray new];
    UITextField *filed  = [[UITextField alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width, 60)];
    filed.backgroundColor = [UIColor lightTextColor];
    filed.delegate = self;
    filed.returnKeyType = UIReturnKeySend;
    filed.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:filed];
    filed.backgroundColor = [UIColor whiteColor];
    filed.placeholder = @"请输入消息";
    
    
    [[xmppManage sharedManage] getmessage:^void(NSString *messahe) {
        [self.allDataArr addObject:@{@"isme":@"0",@"message":messahe}];
        [self.tableView reloadData];
        if (self.allDataArr.count>2) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:self.allDataArr.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allDataArr.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [self.allDataArr[indexPath.row] valueForKey:@"message"];
   CGSize size = [self sizeWithString:str font:[UIFont systemFontOfSize:14] constraintSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-180, 1000)];
    
    return size.height>44?size.height+10:54;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mianTableViewCell *cell = [mianTableViewCell new];
    otherTableViewCell *other = [otherTableViewCell new];
    NSString *isme = [self.allDataArr[indexPath.row] valueForKey:@"isme"];
    NSString *str = [self.allDataArr[indexPath.row] valueForKey:@"message"];
    str =[@"    " stringByAppendingString:str];
    if ([isme isEqualToString:@"1"]) {
        
        if (str.length) {
            CGSize size = [self sizeWithString:str font:[UIFont systemFontOfSize:14] constraintSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-170, 1000)];;
            CGFloat x = [UIScreen mainScreen].bounds.size.width- 44 -size.width- 40;
            cell.message.frame = CGRectMake(x>80?x:80, 10, size.width+40, size.height>44?size.height:44);
            cell.message.text = str;
            cell.backgroundColor = [UIColor grayColor];
            return cell;
        }
    }else{
        CGSize size = [self sizeWithString:str font:[UIFont systemFontOfSize:14] constraintSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-170, 1000)];;
        other.backgroundColor = [UIColor grayColor];
        other.message.frame = CGRectMake(50, 10, size.width+40, size.height>44?size.height:44);
        other.message.text =  str;
        return other;
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60);
        if (self.allDataArr.count>=1) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:self.allDataArr.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });
    [self.view endEditing:YES];
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60);
        if (self.allDataArr.count>=1) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:self.allDataArr.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-80-80-200);
    textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-80-80-200, [UIScreen mainScreen].bounds.size.width, 60);
    
    if (self.allDataArr.count>=1) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:self.allDataArr.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60);
    textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width, 60);
}

/**
 *  发送消息
 */
- (void)sendmsg:(NSString*)msgText
{
    
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.jid];
    // 消息在 body 中
    [msg addBody:msgText];
    // 发送到服务器
    [[xmppManage sharedManage].xmppStream sendElement:msg];
    [self.allDataArr addObject:@{@"isme":@"1",@"message":msgText}];
   dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
   });
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [self sendmsg:textField.text];
    textField.text = @"";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60);
        if (self.allDataArr.count>=1) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:self.allDataArr.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });
    
    return YES;
}


-(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constraintSize:(CGSize)constraintSize
{
    CGSize stringSize = CGSizeZero;
    
    NSDictionary *attributes = @{NSFontAttributeName:font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    CGRect stringRect = [string boundingRectWithSize:constraintSize options:options attributes:attributes context:NULL];
    stringSize = stringRect.size;
    
    return stringSize;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [xmppManage sharedManage].messageBlock = nil;
}

@end