//
//  ViewController.m
//  aaa
//
//  Created by 孙苏 on 2017/4/4.
//  Copyright © 2017年 sunsu. All rights reserved.
//

#import "ViewController.h"
#import "MessageConsultingViewController.h"
#import "AddImageViewController.h"
#import "SelectPickerViewController.h"
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor  whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 100, 50, 30);
    button.backgroundColor = [UIColor yellowColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"男" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"sex"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 30)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];

//    [self.view addSubview:button];
    

    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)pickerView:(UIButton *)sender {
    SelectPickerViewController * vc = [[SelectPickerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)jump:(UIButton *)sender {
    MessageConsultingViewController  * vc = [[MessageConsultingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addImage:(UIButton *)sender {
    AddImageViewController * vc = [[AddImageViewController alloc]init];
    [self.navigationController   pushViewController:vc animated:YES];
}

@end
