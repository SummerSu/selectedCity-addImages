//
//  MiddleView.m
//  aaa
//
//  Created by 孙苏 on 2017/5/5.
//  Copyright © 2017年 sunsu. All rights reserved.
//

#import "MiddleView.h"

@interface MiddleView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *interrogationPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *consultingRoomLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UITextView *infomationTextView;

@property (weak, nonatomic) IBOutlet UILabel *firstLine;
@property (weak, nonatomic) IBOutlet UILabel *secondLine;
@property (weak, nonatomic) IBOutlet UILabel *thirdLine;
@property (weak, nonatomic) IBOutlet UILabel *fourthLine;

@property (weak, nonatomic) IBOutlet UIButton *cardBtn;





@end


@implementation MiddleView


+(instancetype)addMiddleView
{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"MiddleView" owner:nil options:nil];
    return [objs lastObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.infomationTextView.delegate = self;
}

- (IBAction)medicalRecordBtn:(UIButton *)sender {
    NSLog(@"11111");
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedMedicalRecordBtn)]) {
        [self.delegate clickedMedicalRecordBtn];
    }
    
}
- (IBAction)clickedBtnForDepartment:(UIButton *)sender {
    NSLog(@"22222");
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedDepartmentBtn)]) {
        [self.delegate clickedDepartmentBtn];
    }

}
- (IBAction)clickedConsultingRoomBtn:(UIButton *)sender {
    NSLog(@"3333");
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedConsultingRoomsBtn)]) {
        [self.delegate clickedConsultingRoomsBtn];
    }

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat labelH = 44;
    CGFloat labelW = 50;
    self.interrogationPersonLabel.frame = CGRectMake(0, 0, labelW, labelH);
    self.cardBtn.frame = CGRectMake(self.frame.size.width-3*labelW, 0, 3*labelW, 44);
    self.cardBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.cardBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.cardBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    self.firstLine.frame = CGRectMake(0, 44, self.frame.size.width, 1);
    
    self.departmentLabel.frame = CGRectMake(0, labelH, labelW, labelH);
    self.departmentBtn.frame = CGRectMake(CGRectGetMaxX(self.departmentLabel.frame)-5, self.departmentLabel.frame.origin.y, self.frame.size.width*0.5-self.departmentLabel.frame.size.width-5, labelH);
    self.departmentBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.departmentBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    self.thirdLine.frame = CGRectMake( self.frame.size.width*0.5-5, labelH, 1, labelH);
    
    self.consultingRoomLabel.frame = CGRectMake(self.frame.size.width*0.5, labelH, labelW, labelH);
    self.consultingRoomBtn.frame = CGRectMake(CGRectGetMaxX(self.consultingRoomLabel.frame), labelH, self.frame.size.width*0.5-self.consultingRoomLabel.frame.size.width, labelH);
    self.consultingRoomBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.consultingRoomBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    self.secondLine.frame = CGRectMake(0, 2*labelH, self.frame.size.width, 1);
    
    self.infomationTextView.frame = CGRectMake(0, 2*labelH+1, self.frame.size.width, 2*labelH);
    self.tipsLabel.frame = self.infomationTextView.frame;
    self.tipsLabel.textAlignment = NSTextAlignmentJustified;
    self.fourthLine.frame = CGRectMake(0, CGRectGetMaxY(self.infomationTextView.frame),self.frame.size.width , 1);
    
}

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





@end
