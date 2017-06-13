//
//  AddImageViewController.m
//  aaa
//
//  Created by 孙苏 on 2017/5/6.
//  Copyright © 2017年 sunsu. All rights reserved.
//

#import "AddImageViewController.h"

#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height




@interface AddImageViewController ()<UIGestureRecognizerDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
  NSMutableArray *  _photoArray;
    int deleteCount;//缩小前的删除数
     UIImageView *_fullImageView;//当前看得图片
    CGRect _frame;
    BOOL isdele;//判断是否删除
    NSInteger buttonTag;//所删除的button的tag
}
@property(nonatomic,strong)UIView               * photoView;
@property(nonatomic,strong)UIButton            * addPhotoButton;
@property (strong,nonatomic)UIScrollView    * imageScrollView;//大图查看
@end

@implementation AddImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    deleteCount=0;
    //照片墙
    _photoArray=[[NSMutableArray alloc] init];
    isdele = NO;
    //添加照片按钮
    self.photoView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 150)];
    self.photoView.backgroundColor = [UIColor cyanColor];
    self.addPhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 50, 50)];
    [self.addPhotoButton setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    [self.addPhotoButton addTarget:self action:@selector(clickAddPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoView addSubview:self.addPhotoButton];
    [self.view addSubview:self.photoView];
    
    
}

-(void)clickAddPhoto:(UIButton *)sender{

        
        UIAlertController *alertController = [[UIAlertController alloc]init];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击取消");
        }]];
    
        [alertController addAction:[UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            //    elcPicker.maximumImagesCount = 9 - self.imageArray.count; //选择图像的最大数量设置为9
            elcPicker.maximumImagesCount = 9;
            elcPicker.returnsOriginalImage = YES; //只返回fullScreenImage,不是fullResolutionImage
            elcPicker.returnsImage = YES; //如果是的 返回UIimage。如果没有,只返回资产位置信息
            elcPicker.onOrder = YES; //对多个图像选择、显示和返回的顺序选择图像
            elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //支持图片和电影类型
            
            elcPicker.imagePickerDelegate = self;
            [self presentViewController:elcPicker animated:YES completion:nil];

        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"打开摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //调用照相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;  //调用相机
            [self presentViewController:picker animated:YES completion:NULL];//进入照相界面

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
            if (i>4) {
                button.frame=CGRectMake(20+(i-5)*(50+7.5), 80, 50, 50);
            }else{
                button.frame=CGRectMake(20+i*(50+7.5), 10, 50, 50);
            }
            button.tag=i+1;
            [button setBackgroundImage:[_photoArray objectAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(bigImage:) forControlEvents:UIControlEventTouchUpInside];
            [self.photoView addSubview:button];
            
            if (i==_photoArray.count-1) {
                if (i>3) {
                    self.addPhotoButton.frame=CGRectMake(20+(i-4)*(50+7.5), 80, 50, 50);
                }else{
                    self.addPhotoButton.frame=CGRectMake(button.frame.origin.x+button.frame.size.width+7.5, 10, 50, 50);
                }
                
            }
            
            if (i==9) {
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
        self.addPhotoButton.frame=CGRectMake(20, 20, 50, 50);
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
#pragma mark-UI control

//拍摄完成后要执行的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (_photoArray.count>9) {
//        [self showMsg:@"最多10张"];
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
            button.frame=CGRectMake(256, 10, 50, 50);
            [button setImageEdgeInsets:UIEdgeInsetsMake(15, 17, 15, 17)];
            button.tag=i+1100;
            [button setImage:[UIImage imageNamed:@"shanchu.png"] forState:UIControlStateNormal];
            
            
            [button addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
            
        }
    }];
}
//缩小
-(void)zoomOutAction:(UIGestureRecognizer*)tap{
    if (self.imageScrollView.contentOffset.x/kScreenWidth<=4) {
        _frame.origin.x =20+(self.imageScrollView.contentOffset.x/kScreenWidth)*(50+7.5);
    }else{
        _frame.origin.x =20+((self.imageScrollView.contentOffset.x/kScreenWidth)-5)*(50+7.5);
        
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
