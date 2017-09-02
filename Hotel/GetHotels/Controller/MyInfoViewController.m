//
//  MyInfoViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/8/21.
//  Copyright © 2017年 Yixin studio. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoTableViewCell.h"
#import "UserModel.h"

@interface MyInfoViewController ()<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
- (IBAction)loginBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) NSArray *myInfoArr;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (strong, nonatomic) UIImagePickerController *imagePC;
@property (strong,nonatomic) UIImageView *navigationImageView;


@end

@implementation MyInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myInfoArr = @[@{@"leftIcon":@"hotel",@"title":@"我的酒店"},@{@"leftIcon":@"aviation",@"title":@"我的航空"},@{@"leftIcon":@"setting",@"title":@"账户设置"},@{@"leftIcon":@"protocol",@"title":@"使用协议"},@{@"leftIcon":@"电话",@"title":@"联系客服"}];    // Do any additional setup after loading the view.
    [self setNavigationItem];
    [self addTapGestureRecognizer:_headImageView];
    _navigationImageView= [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    self.navigationImageView = _navigationImageView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，隐藏导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    if([Utilities loginCheck]){
        self.navigationImageView.hidden = YES;
        
        //已登录
        _loginBtn.hidden=YES;
        _nameLabel.hidden=NO;
        UserModel *user=[[StorageMgr singletonStorageMgr]objectForKey:@"UserInfo"];
        //[_headImageView sd_setImageWithURL:[NSURL URLWithString:user.headImg]placeholderImage:[UIImage imageNamed:@"用户"]];
        _nameLabel.text=user.nickName;
        _grade.hidden=NO;
        UIImage  *stars=[UIImage imageNamed:@"star"];
        switch (user.state) {
            case 1:
                _star1.image=stars;
                break;
            case 2:
                _star1.image=stars;
                _star2.image=stars;
            case 3:
                _star1.image=stars;
                _star2.image=stars;
                _star3.image=stars;
            default:
                break;
        }
        
        
    }
    else{
        _loginBtn.hidden=NO;
        _nameLabel.hidden=YES;
        
        _grade.hidden=YES;
        _headImageView.image=[UIImage imageNamed:@"用户"];
        _nameLabel.text=@"游客";
    }
}

-(UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//设置导航栏样式
- (void)setNavigationItem{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
    self.navigationItem.title = @"我的";
    
    [self.navigationController.navigationBar setBarTintColor:HEAD_THEMECOLOR];
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(15, 100, 240);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
}

//添加一个单击手势事件
- (void)addTapGestureRecognizer: (id)any{
//    //初始化一个单击手势，设置它的响应事件为tapClick:
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
//    //用户交互启用
    _headImageView.userInteractionEnabled = YES;
//    //将手势添加给入参
    [_headImageView addGestureRecognizer:tap];
}

//小图单击手势响应事件
- (void)tapClick: (UITapGestureRecognizer *)tap{
    if([Utilities loginCheck]){
        if (tap.state == UIGestureRecognizerStateRecognized){
            NSLog(@"你单击了");
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self pickImage:UIImagePickerControllerSourceTypeCamera];
            }];
            UIAlertAction *choosePhoto = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self pickImage:UIImagePickerControllerSourceTypePhotoLibrary];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [actionSheet addAction:takePhoto];
            [actionSheet addAction:choosePhoto];
            [actionSheet addAction:cancelAction];
            [self presentViewController:actionSheet animated:YES completion:nil];
        }

    }
}
- (void)pickImage:(UIImagePickerControllerSourceType)sourceType {
    NSLog(@"按钮被按了");
    //判断当前选择的图片选择器控制器类型是否可用
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        //神奇的nil
        _imagePC = nil;
        //初始化一个图片选择器控制器对象
        _imagePC = [[UIImagePickerController alloc] init];
        //签协议
        _imagePC.delegate = self;
        //设置图片选择器控制器类型
        _imagePC.sourceType = sourceType;
        //设置选中的媒体文件是否可以被编辑
        _imagePC.allowsEditing = YES;
        //设置可以被选择的媒体文件的类型
        _imagePC.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:_imagePC animated:YES completion:nil];
    } else {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:sourceType == UIImagePickerControllerSourceTypeCamera ? @"您当前的设备没有照相功能" : @"您当前的设备无法打开相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:confirmAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

//当选择完媒体文件后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //根据UIImagePickerControllerEditedImage这个键去拿到我们选中的已经编辑过的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //将上面拿到的图片设置为按钮的背景图片
    //将照片存到媒体库
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    self.headImageView.image = image;
    
    //将照片存到沙盒
    [self saveImage:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存图片
- (void) saveImage:(UIImage *)currentImage {
    //设置照片的品质
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    NSLog(@"%@",NSHomeDirectory());
    // 获取沙盒目录
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/currentImage.png"];
    // 将图片写入文件
    [imageData writeToFile:filePath atomically:NO];
    //将选择的图片显示出来
       [self.headImageView setImage:[UIImage imageWithContentsOfFile:filePath]];
    
}


//当取消选择后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //用model的方式返回上一页
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 照片存到本地后的回调
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"存储成功");
    } else {
        NSLog(@"存储失败：%@", error);
    }
}

#pragma mark - tableView
//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myInfoArr.count;
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 1;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myInfoCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _myInfoArr[indexPath.section];
    

    cell.iconView.image = [UIImage imageNamed:dict[@"leftIcon"]];
    cell.titleLabel.text = dict[@"title"];
    return cell;
}
//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if(section == 1){
        return 0;
    }
    return 1.f;
}

//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([Utilities loginCheck]){
        switch (indexPath.section) {
            case 0:
                [self performSegueWithIdentifier:@"ToHotel" sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:@"ToAir" sender:self];
                break;
            case 2:
                [self performSegueWithIdentifier:@"ToSafe" sender:self];
                break;
            case 3:
                [self performSegueWithIdentifier:@"ToProtocol" sender:self];
                    break;
            default:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否拨打客服电话？" message:@"13286535443" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self callAction];
                }];
                UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:actionA];
                [alert addAction:actionB];
                [self presentViewController:alert animated:YES completion:nil];
                
            }

                break;
        }

    }else{
        UINavigationController *signNavi=[Utilities getStoryboardInstance:@"Login" byIdentity:@"SignNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
    }
    
    }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0 )
    {
        return 10;
    }else if (section == 2){
        return 10;
    }else{
        return 0;
    }
}
#pragma mark - buttonAction

- (IBAction)loginBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    
}

- (IBAction)callAction{
    NSString *phone = @"13286535443";
    NSString *callStr = [NSString stringWithFormat:@"tel:%@", phone];
    NSURL *callURL = [NSURL URLWithString:callStr];
    [[UIApplication sharedApplication] openURL:callURL];
    NSLog(@"%@",phone);
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
@end
