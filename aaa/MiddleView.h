//
//  MiddleView.h
//  aaa
//
//  Created by 孙苏 on 2017/5/5.
//  Copyright © 2017年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MiddleView;

@protocol MiddleViewDelegate <NSObject>

-(void)clickedMedicalRecordBtn;
-(void)clickedDepartmentBtn;
-(void)clickedConsultingRoomsBtn;
@end


@interface MiddleView : UIView
+(instancetype)addMiddleView;
@property (nonatomic,weak)id<MiddleViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *departmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *consultingRoomBtn;

@end
