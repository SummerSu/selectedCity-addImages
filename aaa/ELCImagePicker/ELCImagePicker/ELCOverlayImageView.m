//
//  ELCOverlayImageView.m
//  ELCImagePickerDemo
//
//  Created by Seamus on 14-7-11.
//  Copyright (c) 2014年 ELC Technologies. All rights reserved.
//

#import "ELCOverlayImageView.h"
#import "ELCConsole.h"
@implementation ELCOverlayImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setIndex:(int)_index
{
    self.labIndex.text = [NSString stringWithFormat:@"%d",_index];
}

- (void)dealloc
{
    self.labIndex = nil;
}

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,([UIScreen mainScreen].bounds.size.width - 8) / 4 ,([UIScreen mainScreen].bounds.size.width - 8) / 4)];
        
        [img setImage:image];
        
        [self addSubview:img];
        
//        UIImageView *img = [[UIImageView alloc] init];
//        
//        img.image = image;
        

        
//        if ([[ELCConsole mainConsole] onOrder]) {
//            self.labIndex = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 16, 16)];
//            self.labIndex.backgroundColor = [UIColor greenColor];
//            self.labIndex.clipsToBounds = YES;
//            self.labIndex.textAlignment = NSTextAlignmentCenter;
//            self.labIndex.textColor = [UIColor whiteColor];
//            self.labIndex.layer.cornerRadius = 8;
//            self.labIndex.layer.shouldRasterize = YES;
//            self.labIndex.hidden = NO;
//            //        self.labIndex.layer.borderWidth = 1;
//            //        self.labIndex.layer.borderColor = [UIColor greenColor].CGColor;
//            self.labIndex.font = [UIFont boldSystemFontOfSize:13];
////            [self addSubview:self.labIndex];
//        }
    }
    return self;
}




@end
