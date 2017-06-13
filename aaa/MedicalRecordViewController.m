//
//  MedicalRecordViewController.m
//  aaa
//
//  Created by 孙苏 on 2017/5/12.
//  Copyright © 2017年 sunsu. All rights reserved.
//

#import "MedicalRecordViewController.h"
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface MedicalRecordViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate>
{
    BOOL isAgePickerView;
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    NSString *selectedProvince;

}
@property (nonatomic,strong) UITableView  * recordTableView;
@property (nonatomic,weak) UIButton *Selectbutton;
@property (nonatomic,strong )UIPickerView * pickerView;
@property (nonatomic, strong)NSArray * ageArray;
@property (nonatomic,strong) UIButton *ageButton;
@property (nonatomic,strong) UIButton *placeButton;
@property (nonatomic,strong) UILabel * tipsLabel;
@property (nonatomic,strong) UIButton * confirmBtn;
@end

@implementation MedicalRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"病历卡";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtn)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(comfirm)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.recordTableView];
    [self.view addSubview:self.confirmBtn];
    [self.view addSubview:self.pickerView];
    self.pickerView.hidden = YES;
    
    UITapGestureRecognizer* singleRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPopView)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
    
    
    //年龄数据
    NSMutableArray * ageArrays = [NSMutableArray array];
    for(int i=1;i<=120;i++)
    {
        NSString * ageStr = [NSString stringWithFormat:@"%d",i];
        [ageArrays addObject:ageStr];
    }
    self.ageArray = ageArrays;
    
    //地址数据
     [self requestAreaInfoData];
}


-(void)requestAreaInfoData
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
}


-(void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)comfirm
{

}


-(UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/3, kScreenHeight-40-10, kScreenWidth/3, 40)];
        _confirmBtn.layer.borderWidth =  1;
        _confirmBtn.layer.borderColor = [UIColor grayColor].CGColor;
        _confirmBtn.layer.cornerRadius = 5;
        [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(comfirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}


-(UITableView *)recordTableView
{
    if (!_recordTableView) {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _recordTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _recordTableView.delegate = self;
        _recordTableView.dataSource = self;
        _recordTableView.showsVerticalScrollIndicator= NO;
       _recordTableView.bounces = NO;
         _recordTableView.separatorInset = UIEdgeInsetsZero;
        _recordTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _recordTableView;
}

-(UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-120, kScreenWidth, 120)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        
    }
    return _pickerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identifier = @"MedicalRecordCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //取消选中颜色
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    CGFloat labelW = 100;
    CGFloat cellH = 44;
    CGFloat margin = 10;
    
    if (indexPath.row == 0) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(margin, 0, labelW, cellH)];
        label.text =  @"姓名:";
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        UITextField * nameTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, cell.frame.size.width-labelW, cellH)];
        nameTF.placeholder  = @"您的姓名";
        [cell.contentView addSubview:nameTF];
        
    }
    
    if (indexPath.row == 1) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(margin, 0, labelW, cellH)];
        label.text =  @"性别:";
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        NSArray * titlearray = @[@"男",@"女"];
        int col = 2;
        int margin = 10;
        for (int i = 0; i < titlearray.count; i++) {
            int page = i/col;
            int index = i%col;
            CGFloat btnsW = kScreenWidth * 0.5-50;//两个按钮占的宽度
            CGRect frame = CGRectMake((kScreenWidth-btnsW) + index*(btnsW - (col + 1)*margin)/col + margin*index,40*page +7,(btnsW - (col + 1)*margin)/col,30 );
            UIButton *BtnSearch = [[UIButton alloc]initWithFrame:frame];
            BtnSearch.layer.cornerRadius = 5;
            BtnSearch.layer.masksToBounds = YES;
//            BtnSearch.backgroundColor = [UIColor lightGrayColor];
            BtnSearch.tag = i;
            
            [BtnSearch setImage:[UIImage imageNamed:@"sex"] forState:UIControlStateSelected];
            [BtnSearch setImage:[UIImage imageNamed:@"sex_pre"] forState:UIControlStateNormal];
            [BtnSearch setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 30)];
            [BtnSearch setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
            
            [BtnSearch setTitle:titlearray[i] forState:UIControlStateNormal];
            [BtnSearch setTitle:titlearray[i] forState:UIControlStateSelected];
            NSLog(@"title=%@",[BtnSearch titleForState:UIControlStateNormal]);

            [BtnSearch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [BtnSearch setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            BtnSearch.titleLabel.font = [UIFont systemFontOfSize:14];
            [BtnSearch addTarget:self action:@selector(SelectBtnSearch:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [BtnSearch setImage:[UIImage imageNamed:@"sex"] forState:UIControlStateSelected];
                [BtnSearch setImage:[UIImage imageNamed:@"sex_pre"] forState:UIControlStateNormal];
                BtnSearch.selected = YES;
                self.Selectbutton = BtnSearch;
            }
            [cell.contentView addSubview:BtnSearch];
        }
    }
    
    if (indexPath.row == 2) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(margin, 0, labelW, cellH)];
        label.text =  @"年龄:";
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        UIButton * ageBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-2*margin-labelW, 0, labelW, 44)];
        [ageBtn setTitle:@"18" forState:UIControlStateNormal];
        [ageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:ageBtn];
        [ageBtn addTarget:self action:@selector(selectedAgeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [ageBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

        self.ageButton = ageBtn;
    }
    
    if (indexPath.row == 3) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(margin, 0, labelW, cellH)];
        label.text =  @"手机号:";
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        UITextField * phoneTf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, cell.frame.size.width-labelW, cellH)];
        [cell.contentView addSubview:phoneTf];
        phoneTf.placeholder = @"输入手机号获得医生的回复";
        phoneTf.keyboardType = UIKeyboardTypePhonePad;

        
    }
    
    if (indexPath.row == 4) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(margin, 0, labelW, cellH)];
        label.text =  @"所在省份:";
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        UIButton * placeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-2*margin-2*labelW, 0, 2*labelW, 44)];
        [placeBtn setTitle:@"北京市 北京市 东城区" forState:UIControlStateNormal];
        [placeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:placeBtn];
        placeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [placeBtn addTarget:self action:@selector(selectedPlaceClicked:) forControlEvents:UIControlEventTouchUpInside];
        [placeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

        self.placeButton = placeBtn;
    }
    
    if (indexPath.row == 5) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(margin, 0, 2*labelW, cellH*0.6)];
        label.text =  @"已在医院确诊的疾病：";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(margin, label.frame.size.height, kScreenWidth-2*margin, 120-label.frame.size.height)];
//        textView.layer.borderWidth = 1;
//        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textView.delegate = self;
        
        UILabel    * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, 20)];
        tipLabel.text = @"如冠心病 高血压 偏头疼等";
        tipLabel.textColor = [UIColor lightGrayColor];
        tipLabel.font = [UIFont systemFontOfSize:12];
        self.tipsLabel = tipLabel;
        [cell.contentView addSubview:textView];
        [cell.contentView addSubview:tipLabel];

    }
    
       return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 120;
    }
    return 44;
}

//去掉cell选中高亮状态
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [_recordTableView deselectRowAtIndexPath:indexPath animated:NO];
//}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}


    
-(void)SelectBtnSearch:(UIButton * )Btn
{
    
        if (!Btn.isSelected) {
            self.Selectbutton.selected = !self.Selectbutton.selected;
            [self.Selectbutton setImage:[UIImage imageNamed:@"sex_pre"] forState:UIControlStateNormal];
            Btn.selected = !Btn.selected;
            [Btn setImage:[UIImage imageNamed:@"sex"] forState:UIControlStateSelected];
            self.Selectbutton = Btn;
    }
    
    
}

-(void)selectedAgeClicked:(UIButton * )sender
{
    [self.view endEditing:YES];
    isAgePickerView = YES;
    self.pickerView.hidden = NO;
    [self showPickerView];
    [self.pickerView reloadAllComponents];

}

-(void)selectedPlaceClicked:(UIButton * )sender
{
    [self.view endEditing:YES];
     isAgePickerView = NO;
    self.pickerView.hidden = NO;
    [self showPickerView];

    [self.pickerView reloadAllComponents];

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (isAgePickerView) {
        return 1;
    }else{
        return 3;
    }
    
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (isAgePickerView) {
        return self.ageArray.count;

    }else{
        if (component == PROVINCE_COMPONENT) {
            return [province count];
        }
        else if (component == CITY_COMPONENT) {
            return [city count];
        }
        else {
            return [district count];
        }
    }
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (isAgePickerView) {
        return [self.ageArray objectAtIndex:row];
    }else{
        if (component == PROVINCE_COMPONENT) {
            return [province objectAtIndex: row];
        }
        else if (component == CITY_COMPONENT) {
            return [city objectAtIndex: row];
        }
        else {
            return [district objectAtIndex: row];
        }

    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (isAgePickerView) {
        if (component == 0) {
            [pickerView reloadComponent:0];
        }
        NSString * age = [self.ageArray objectAtIndex: [_pickerView selectedRowInComponent:0]];
        [self.ageButton setTitle:age   forState:UIControlStateNormal];
    }else{
    
        if (component == PROVINCE_COMPONENT) {
            selectedProvince = [province objectAtIndex: row];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
            NSArray *cityArray = [dic allKeys];
            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;//递减
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;//上升
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0; i<[sortedArray count]; i++) {
                NSString *index = [sortedArray objectAtIndex:i];
                NSArray *temp = [[dic objectForKey: index] allKeys];
                [array addObject: [temp objectAtIndex:0]];
            }
            
            city = [[NSArray alloc] initWithArray: array];
            
            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
            district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
            [self.pickerView selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
            [self.pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            [self.pickerView reloadComponent: CITY_COMPONENT];
            [self.pickerView reloadComponent: DISTRICT_COMPONENT];
            
        }else if (component == CITY_COMPONENT) {
            NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[province indexOfObject: selectedProvince]];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
            NSArray *dicKeyArray = [dic allKeys];
            if (dicKeyArray.count<=0) {
                return;
            }
            //        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            //
            //            if ([obj1 integerValue] > [obj2 integerValue]) {
            //                return (NSComparisonResult)NSOrderedDescending;
            //            }
            //
            //            if ([obj1 integerValue] < [obj2 integerValue]) {
            //                return (NSComparisonResult)NSOrderedAscending;
            //            }
            //            return (NSComparisonResult)NSOrderedSame;
            //        }];
            //
            //        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [dicKeyArray objectAtIndex: row]]];
            NSArray *cityKeyArray = [cityDic allKeys];
            
            district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
            [self.pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            [self.pickerView reloadComponent: DISTRICT_COMPONENT];
        }
        [self.placeButton setTitle:[self allAddressName] forState:UIControlStateNormal];
    }

    
}


-(NSString *)allAddressName
{
    NSInteger provinceIndex = [self.pickerView selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [self.pickerView selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [self.pickerView selectedRowInComponent: DISTRICT_COMPONENT];
    
    NSString *provinceStr = [province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    NSString *districtStr = [district objectAtIndex:districtIndex];
    
    return [NSString stringWithFormat:@"%@ %@ %@",provinceStr,cityStr,districtStr];
}

-(void)hiddenPopView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerView.frame = CGRectMake(0,kScreenHeight ,kScreenWidth ,120 );
    }];
    [self.view endEditing:YES];
}

-(void)showPickerView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerView.frame = CGRectMake(0,kScreenHeight -120,kScreenWidth ,120 );
    }];
}

#pragma mark textViewDelegate
- (void) textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [_tipsLabel setHidden:NO];
    }else{
        [_tipsLabel setHidden:YES];
    }
}


-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    [_tipsLabel setHidden:YES];
    return YES;
}

//判断手机号码
- (BOOL) isMobile:(NSString *)mobileNumber{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1[3-5|8|7]\\d{9}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumber]
         || [regextestcm evaluateWithObject:mobileNumber]
         || [regextestct evaluateWithObject:mobileNumber]
         || [regextestcu evaluateWithObject:mobileNumber])) {
        return YES;
    }
    
    return NO;
}



@end
