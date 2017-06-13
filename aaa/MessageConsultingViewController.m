//
//  MessageConsultingViewController.m
//  aaa
//
//  Created by 孙苏 on 2017/5/5.
//  Copyright © 2017年 sunsu. All rights reserved.
//

#import "MessageConsultingViewController.h"
#import "MiddleView.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MedicalRecordViewController.h"


#define Margins  15      //两边间隙
#define ViewY    64       //如果有自定义的导航栏就设置为0
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

#define photoCount   3     //添加照片张数
#define photoWH        ([UIScreen mainScreen].bounds.size.width-2*Margins-(photoCount-1)*Margins)/3

#define kFirstComponent 0
#define kSubComponent 1

@interface MessageConsultingViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ELCImagePickerControllerDelegate,MiddleViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray *  _photoArray;
    int deleteCount;//缩小前的删除数
    UIImageView *_fullImageView;//当前看得图片
    CGRect _frame;
     BOOL isdele;//判断是否删除
     NSInteger buttonTag;//所删除的button的tagß
    

    //选择科室诊室
    NSArray *pickerArray;
    NSArray *subPickerArray;
    NSDictionary *dicPicker;
    
}
@property(nonatomic,strong)UIView               * photoView;
@property(nonatomic,strong)UIButton            * addPhotoButton;
@property (strong,nonatomic)UIScrollView    * imageScrollView;//大图查看


@property (nonatomic, strong) UIImageView * topImgView;
@property (nonatomic, strong) MiddleView * middleBtns;//问诊人、选择科室、诊室以及描述View
@property (nonatomic,strong) UIButton * bottomCommitBtn;


@property (nonatomic,strong) UIPickerView *selectPicker;

@end

@implementation MessageConsultingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar];
    [self addSubView];
   
}


-(void)addNavigationBar
{
    self.title =  @"留言咨询";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtn)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitBtn)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
}




-(void)addSubView
{
    //初始化
    deleteCount=0;
    _photoArray=[[NSMutableArray alloc] init];
     isdele=NO;
    

    
    
    pickerArray = [NSArray arrayWithObjects:@"内科",@"外科",@"妇科", nil];
    dicPicker = [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSArray arrayWithObjects:@"过敏性疾病门诊",@"普通内科",@"风湿性内科",            nil], @"内科",
                 [NSArray arrayWithObjects:@"外科1",@"外科2",@"外科3",            nil], @"外科",
                 [NSArray arrayWithObjects:@"妇科1",@"妇科2",@"妇科3", nil], @"妇科",nil];
    
    subPickerArray = [dicPicker objectForKey:pickerArray[0]];

    
    [self.view addSubview:self.topImgView];
    [self.view addSubview:self.middleBtns];
    [self.view addSubview:self.photoView];
    [self.photoView addSubview:self.addPhotoButton];
    [self.view addSubview:self.bottomCommitBtn];
    

    
}


#pragma mark 懒加载
-(UIImageView *)topImgView
{
    if (!_topImgView) {
      
        CGRect topFrame = CGRectMake(Margins, ViewY,kScreenWidth-2*Margins , kScreenHeight * 0.2);
        _topImgView = [[UIImageView alloc]initWithFrame:topFrame];
        _topImgView.backgroundColor = [UIColor cyanColor];
        _topImgView.userInteractionEnabled = YES;
        
        // 单击的 Recognizer
        UITapGestureRecognizer* singleRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_topImgView addGestureRecognizer:singleRecognizer];
    }
    return _topImgView;
}


-(MiddleView *)middleBtns
{
    if (!_middleBtns) {
        _middleBtns = [MiddleView addMiddleView];
        _middleBtns.frame = CGRectMake(Margins, CGRectGetMaxY(self.topImgView.frame), kScreenWidth-2*Margins, 88*2);
        _middleBtns.userInteractionEnabled = YES;
        _middleBtns.delegate = self;
    }
    return _middleBtns;
}


- (UIButton *)addPhotoButton
{
    if (!_addPhotoButton)
    {
        _addPhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(Margins, 0, photoWH, photoWH)];
        [_addPhotoButton setImage:[UIImage imageNamed:@"+"] forState:(UIControlStateNormal)];
        [_addPhotoButton setTitle:@"添加图片" forState:UIControlStateNormal];
        [_addPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addPhotoButton addTarget:self action:@selector(clickAddPhoto:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addPhotoButton;
}

-(UIView *)photoView
{
    if (!_photoView) {
        _photoView = [[UIView alloc]initWithFrame:CGRectMake(Margins, CGRectGetMaxY(self.middleBtns.frame)+10, kScreenWidth-2*Margins, 150)];
    }
    return _photoView;
}

-(UIButton *)bottomCommitBtn
{
    if (!_bottomCommitBtn) {
        _bottomCommitBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*Margins, kScreenHeight-40-20, kScreenWidth-4*Margins, 40)];
        _bottomCommitBtn.layer.borderWidth =  1;
        _bottomCommitBtn.layer.borderColor = [UIColor grayColor].CGColor;
        _bottomCommitBtn.layer.cornerRadius = 2;
        [_bottomCommitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bottomCommitBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    return _bottomCommitBtn;
}


-(UIPickerView *)selectPicker
{
    if (!_selectPicker) {
        CGRect frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-200, [UIScreen mainScreen].bounds.size.width, 200);
        _selectPicker = [[UIPickerView alloc]initWithFrame:frame];
        _selectPicker.delegate = self;
        _selectPicker.dataSource = self;
        _selectPicker.backgroundColor = [UIColor whiteColor];
        _selectPicker.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _selectPicker.layer.borderWidth = 1.0f;
    }
    return _selectPicker;
}

#pragma mark     UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == kFirstComponent){
        return [pickerArray count];
    }else {
        return [subPickerArray count];
    }
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == kFirstComponent) {
        subPickerArray = [dicPicker objectForKey:[pickerArray objectAtIndex:row]];
        [pickerView selectRow:0 inComponent:kSubComponent animated:YES];
        [pickerView reloadComponent:kSubComponent];
        
    }else  if (component == kSubComponent) {
        [pickerView reloadComponent:kSubComponent];
    }
    
    NSInteger firstViewRow = [_selectPicker selectedRowInComponent:kFirstComponent];
    NSInteger subViewRow = [_selectPicker selectedRowInComponent:kSubComponent];
    NSString * firstString = [pickerArray objectAtIndex:firstViewRow];
    NSString * subString =  [[dicPicker objectForKey:[pickerArray objectAtIndex:firstViewRow]] objectAtIndex:subViewRow] ;
    [self.middleBtns.departmentBtn setTitle:firstString forState:UIControlStateNormal];
    [self.middleBtns.consultingRoomBtn setTitle:subString forState:UIControlStateNormal];
    
}



-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == kFirstComponent){
        return [pickerArray objectAtIndex:row];
    }else {
        return [subPickerArray objectAtIndex:row];
    }
}


#pragma mark 点击事件
-(void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)commitBtn
{

}

-(void)handleSingleTapFrom
{
    NSLog(@"点击图片跳转");
}


-(void)clickedMedicalRecordBtn
{
    //跳转到就诊卡页
    MedicalRecordViewController * vc = [[MedicalRecordViewController alloc]init];
    [self.navigationController   pushViewController:vc animated:YES];
}
-(void)clickedDepartmentBtn
{
    [self.view addSubview:self.selectPicker];
}
-(void)clickedConsultingRoomsBtn
{
    
}

#pragma mark  图片选择
-(void)clickAddPhoto:(UIButton *)sender{
    
    
    UIAlertController *alertController = [[UIAlertController alloc]init];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        elcPicker.maximumImagesCount = photoCount;
        elcPicker.returnsOriginalImage = YES; //只返回fullScreenImage,不是fullResolutionImage
        elcPicker.returnsImage = YES; //如果是的 返回UIimage。如果没有,只返回资产位置信息
        elcPicker.onOrder = YES; //对多个图像选择、显示和返回的顺序选择图像
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //支持图片和电影类型
        
        elcPicker.imagePickerDelegate = self;
        [self presentViewController:elcPicker animated:YES completion:nil];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"打开摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerControllerSourceType sourcType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = sourcType;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
            
        }else{
            UIAlertController   * alertController = [UIAlertController alertControllerWithTitle:@"摄像头设备不可用" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }

        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//相册
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    NSMutableArray *array = [NSMutableArray array];
    [array removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@", info);
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                //把图片取出来放到数组里面
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [array addObject:image];
            }
            
        }else {
            
        }
    }
    [_photoArray addObjectsFromArray:array];
    NSLog(@"_photoArray = %@",_photoArray);
    //[self.addPhotoButton setImage:images[i] forState:UIControlStateNormal];
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    
    NSLog(@"%@", info);
    
}

-(void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    // 3. 关闭照片选择控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}


//刷新addbutton
-(void)reloadAddButton{
    if (_photoArray.count>0) {
        for (int i=0; i<_photoArray.count+deleteCount; i++) {
            //NSLog(@"移除所有");
            UIButton *button=(UIButton*)[self.photoView viewWithTag:i+1];
            [button removeFromSuperview];
            button=nil;
        }
        deleteCount=0;
        //NSLog(@"刷新时-----%lu",(unsigned long)_photoArray.count);
        for (int i=0; i<_photoArray.count; i++) {
            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
            if (i>3) {
                button.frame=CGRectMake((i-4)*(photoWH+Margins), photoWH+10, photoWH, photoWH);
            }else{
                button.frame=CGRectMake(i*(photoWH+Margins), 10, photoWH+10, photoWH);
            }
            button.tag=i+1;
            [button setBackgroundImage:[_photoArray objectAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(bigImage:) forControlEvents:UIControlEventTouchUpInside];
            [self.photoView addSubview:button];
            
            if (i==_photoArray.count-1) {
                if (i>3) {
                    self.addPhotoButton.frame=CGRectMake((i-4)*(photoWH+Margins), photoWH+10, photoWH, photoWH);
                }else{
                    self.addPhotoButton.frame=CGRectMake(button.frame.origin.x+button.frame.size.width+Margins, 10, photoWH, photoWH);
                }
            }
            
            //张的时候隐藏按钮
            if (i==photoCount) {
                self.addPhotoButton.hidden=YES;
                
            }else{
                self.addPhotoButton.hidden=NO;
            }
            
        }
    }else{
        //如果数组为0 删除干净了
        for (int i=0; i<_photoArray.count+deleteCount; i++) {
            //NSLog(@"移除所有");
            UIButton *button=(UIButton*)[self.photoView viewWithTag:i+1];
            [button removeFromSuperview];
            button=nil;
        }
        deleteCount=0;
        //NSLog(@"删除干净刷新时-----%lu",(unsigned long)_photoArray.count);
        self.addPhotoButton.frame=CGRectMake(0, 0, photoWH, photoWH);
        self.addPhotoButton.hidden=NO;
        
    }
}

-(void)removeMyView:(UIImageView*)imageV{
    if (_photoArray.count>0) {
        //移除删除imageview 并修改contentSize
        self.imageScrollView.contentSize = CGSizeMake(kScreenWidth*_photoArray.count, kScreenHeight);
        for (int i=0; i<_photoArray.count+deleteCount; i++) {
            UIImageView *imageall=(UIImageView*)[self.imageScrollView viewWithTag:100+i];
            UIButton *button=(UIButton*)[imageall viewWithTag:1100+i];
            if (i<imageV.tag-100) {
                
            }
            if (i==imageV.tag-100) {
                continue;
            }
            if (i>imageV.tag-100) {
                
                imageall.frame=CGRectMake(imageall.frame.origin.x-kScreenWidth, imageall.frame.origin.y, imageall.frame.size.width, imageall.frame.size.height);
                imageall.tag--;
                button.tag--;
                NSLog(@"imageall.tag--%ld   delButton.tag--%ld",(long)imageall.tag,(long)button.tag);
            }
            
        }
        [imageV removeFromSuperview];
        imageV =nil;
    }else{
        [_imageScrollView removeFromSuperview];
        _imageScrollView = nil;
        
        [_fullImageView removeFromSuperview];
        _fullImageView = nil;
        [self reloadAddButton];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.addPhotoButton.hidden=NO;
    [self reloadAddButton];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
#pragma mark imagePickerControllerDelegate
//拍摄完成后要执行的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (_photoArray.count>photoCount) {
        return;
    }
    [_photoArray addObject:image];
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//看大图
-(void)bigImage:(UIButton *)sender{
    
    
    //大图滚动view
    if (self.imageScrollView==nil) {
        self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.imageScrollView.contentSize = CGSizeMake(kScreenWidth*_photoArray.count, kScreenHeight);
        self.imageScrollView.pagingEnabled = YES;
        
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutAction:)];
    //点击那张图片  _fullImageView 就显示那张图片
    if (_fullImageView==nil) {
        
        _fullImageView = [[UIImageView alloc] init];
        
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    NSLog(@"%ld",(long)sender.tag);
    _fullImageView.image = [_photoArray objectAtIndex:sender.tag-1];
    _fullImageView.frame = [sender convertRect:sender.bounds toView:sender.window];
    _frame = _fullImageView.frame;
    self.imageScrollView.contentOffset = CGPointMake((sender.tag-1)*kScreenWidth, 0);
    self.imageScrollView.backgroundColor = [UIColor clearColor];
    
    [sender.window addSubview:self.imageScrollView];
    [sender.window addSubview:_fullImageView];
    [UIView animateWithDuration:0.3f animations:^{
        _fullImageView.frame=self.imageScrollView.frame;
        self.imageScrollView.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        [self.imageScrollView addGestureRecognizer:tap];
        _fullImageView.hidden=YES;
        //图片
        for (int i = 0; i<_photoArray.count; i++) {
            //大图的图片
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight)];
            imageView.contentMode= UIViewContentModeScaleAspectFit;
            imageView.tag=i+100;
            imageView.userInteractionEnabled=YES;
            [self.imageScrollView addSubview:imageView];
            imageView.image=[_photoArray objectAtIndex:i];
            //            //大图的删除按钮
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(kScreenWidth-50-10, 20, 50, 50);
            button.backgroundColor = [UIColor grayColor];
//            [button setImageEdgeInsets:UIEdgeInsetsMake(15, 17,30, 30)];
            button.tag=i+1100;
            [button setImage:[UIImage imageNamed:@"ImageCancelButton"] forState:UIControlStateNormal];
            
            
            [button addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
            
        }
    }];
}
//缩小
-(void)zoomOutAction:(UIGestureRecognizer*)tap{
    if (self.imageScrollView.contentOffset.x/kScreenWidth<=4) {
        _frame.origin.x =20+(self.imageScrollView.contentOffset.x/kScreenWidth)*(photoWH+Margins);
    }else{
        _frame.origin.x =20+((self.imageScrollView.contentOffset.x/kScreenWidth)-5)*(photoWH+Margins);
        
    }
    
    _fullImageView.image =  [_photoArray objectAtIndex:self.imageScrollView.contentOffset.x/kScreenWidth];
    _fullImageView.hidden = NO;
    [_imageScrollView removeFromSuperview];
    [UIView animateWithDuration:.3 animations:^{
        _fullImageView.frame = _frame;
        _imageScrollView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        NSLog(@"缩小时所剩%lu",(unsigned long)_photoArray.count);
        for (int i=0; i<_photoArray.count; i++) {
            UIImageView *imageV=(UIImageView *)[self.imageScrollView viewWithTag:100+i];
            [imageV removeFromSuperview];
            imageV =nil;
            
        }
        [_imageScrollView removeFromSuperview];
        _imageScrollView = nil;
        
        [_fullImageView removeFromSuperview];
        _fullImageView = nil;
        
        [self reloadAddButton];
    }];
    
}

-(void)deletePic:(UIButton*)sender{
    buttonTag=sender.tag;
    if (isdele==NO) {
        UIActionSheet* mySheet = [[UIActionSheet alloc]
                                  initWithTitle:@"要删除这张照片么"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"删除",nil];
        [mySheet showInView:self.view];
    }else{
        isdele=NO;
        UIImageView *imageV=(UIImageView *)[self.imageScrollView viewWithTag:sender.tag-1000];
        imageV.userInteractionEnabled=NO;
        CGPoint fromPoint=imageV.center;
        CGPoint toPoint =CGPointMake(sender.center.x+kScreenWidth*(sender.tag-1100), sender.center.y);
        NSLog(@"%f----%f",toPoint.x,toPoint.y);
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:fromPoint];
        [movePath addQuadCurveToPoint:toPoint controlPoint:CGPointMake(toPoint.x,fromPoint.y)];
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = movePath.CGPath;
        moveAnim.removedOnCompletion = YES;
        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
        scaleAnim.removedOnCompletion = YES;
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
        opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
        opacityAnim.removedOnCompletion = YES;
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim,opacityAnim, nil];
        animGroup.duration = 1;
        [imageV.layer addAnimation:animGroup forKey:nil];
        
        [_photoArray removeObjectAtIndex:imageV.tag-100];
        deleteCount++;
        [self performSelector:@selector(removeMyView:) withObject:imageV afterDelay:1.0f];
    }
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        isdele=YES;
        UIImageView *imageV=(UIImageView *)[self.imageScrollView viewWithTag:buttonTag-1000];
        UIButton *button=(UIButton*)[imageV viewWithTag:buttonTag];
        [self deletePic:button];
        
    }else if (buttonIndex==1){
        isdele=NO;
        
    }
    
}





-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.2 animations:^{
        self.selectPicker.frame = CGRectMake(0,kScreenHeight ,kScreenWidth ,200 );
    }];
    [self.view endEditing:YES];
}


@end
