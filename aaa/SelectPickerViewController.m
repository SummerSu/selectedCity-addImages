//
//  SelectPickerViewController.m
//  aaa
//
//  Created by 孙苏 on 2017/5/10.
//  Copyright © 2017年 sunsu. All rights reserved.
//

#import "SelectPickerViewController.h"

#define kFirstComponent 0
#define kSubComponent 1
@interface SelectPickerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray *pickerArray;
    NSArray *subPickerArray;
    NSDictionary *dicPicker;
}


@property (nonatomic,strong) UIButton  * selectBtn;
@property (nonatomic,strong) UIPickerView *selectPicker;


@end

@implementation SelectPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self.view addSubview:self.selectBtn];
    
    pickerArray = [NSArray arrayWithObjects:@"内科",@"外科",@"妇科", nil];
    dicPicker = [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSArray arrayWithObjects:@"过敏性疾病门诊",@"普通内科",@"风湿性内科",            nil], @"内科",
                 [NSArray arrayWithObjects:@"外科1",@"外科2",@"外科3",            nil], @"外科",
                 [NSArray arrayWithObjects:@"妇科1",@"妇科2",@"妇科3", nil], @"妇科",nil];
    
    subPickerArray = [dicPicker objectForKey:pickerArray[0]];
}


-(UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn =  [[UIButton alloc]initWithFrame:CGRectMake(20, 80, 200, 50)];
        [_selectBtn setTitle:@"内科" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(clickPopPicker:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _selectBtn;
}

-(UIPickerView *)selectPicker
{
    if (!_selectPicker) {
        CGRect frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-200, [UIScreen mainScreen].bounds.size.width, 200);
        _selectPicker = [[UIPickerView alloc]initWithFrame:frame];
        _selectPicker.delegate = self;
        _selectPicker.dataSource = self;
    }
    return _selectPicker;
}


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
    
    [self.selectBtn setTitle:[self seletedAllName] forState:UIControlStateNormal];

}

-(NSString *)seletedAllName
{
    NSInteger firstViewRow = [_selectPicker selectedRowInComponent:kFirstComponent];
    NSInteger subViewRow = [_selectPicker selectedRowInComponent:kSubComponent];
    NSString * firstString = [pickerArray objectAtIndex:firstViewRow];
    NSString * subString =  [[dicPicker objectForKey:[pickerArray objectAtIndex:firstViewRow]] objectAtIndex:subViewRow] ;
    NSString *textString = [[NSString alloc ] initWithFormat:@"%@ %@", firstString, subString];
    return textString;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == kFirstComponent){
        return [pickerArray objectAtIndex:row];
    }else {
        return [subPickerArray objectAtIndex:row];
    }
}

-(void)clickPopPicker:(UIButton *)sender
{
    [self.view addSubview:self.selectPicker];    
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
