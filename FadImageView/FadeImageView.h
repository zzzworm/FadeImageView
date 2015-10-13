//
//  FadeImageView.h
//
//  Created by zzzworm on 15/8/25.
//  Copyright (c) 2015年 nobuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FadeImageView : UIView

-(FadeImageView*) initWithImageList:(NSArray*) imageList;

-(void)fadeToggle;
@property (assign,nonatomic) float animationTime;
@end
