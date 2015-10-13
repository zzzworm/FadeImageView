//
//  FadeImageView.m
//
//  Created by zzzworm on 15/8/25.
//  Copyright (c) 2015年 nobuta. All rights reserved.
//

#import "FadeImageView.h"
#import <POP.h>

static const float kcAnimationTime = 5.0f;

@implementation FadeImageView
{
    NSMutableArray* imageLayers;
    NSMutableArray* bgImageList;
    UIImageView* frontLayer;
    UIImageView* backGroundLayer;
    NSInteger _currentfrontImgIndex;
    BOOL frontShow;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(FadeImageView*) initWithImageList:(NSArray*) imageList;
{
   
    if (self = [super initWithFrame:CGRectZero])
    {
        bgImageList = [imageList copy];
        _currentfrontImgIndex = 0;
        if (bgImageList.count == 1) {
            UIImage *img = [UIImage imageNamed:bgImageList[0]];
            self.layer.contents = (id)img.CGImage;
            self.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        }
        else{
        frontLayer = [UIImageView new];
        frontLayer.alpha = 1.0;
            UIImage* frontImg = [UIImage imageNamed:imageList[0]];
        [frontLayer setImage:frontImg];
        backGroundLayer = [UIImageView new];
        backGroundLayer.alpha = 1.0f;
             UIImage* backgroundImg = [UIImage imageNamed:imageList[1]];
        [backGroundLayer setImage:backgroundImg];
 
            
        [self addSubview:backGroundLayer];
        [self addSubview:frontLayer];

        }
        self.animationTime = kcAnimationTime;
        [self masConstraint];
        frontShow = YES;
    }
    return self;
}


-(void)masConstraint
{
    [frontLayer makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.top.equalTo(self);
        make.left.equalTo(self);
    }];
    [backGroundLayer makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.top.equalTo(self);
        make.left.equalTo(self);
    }];
}

-(void)scaleUpView:(UIImageView *)view
{
    
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
     scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.2, 1.2)];
    //    scaleAnimation.springBounciness = 10.f;
    scaleAnimation.duration =self.animationTime;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [view.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [view.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    POPBasicAnimation *showAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    showAnimation.fromValue = @(1.0);
    showAnimation.toValue = @(0.0);
    showAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    showAnimation.duration = self.animationTime ;
    showAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        _currentfrontImgIndex = (_currentfrontImgIndex+2) % bgImageList.count;
        UIImage* frontImg = [UIImage imageNamed:bgImageList[_currentfrontImgIndex]];
        [view setImage:frontImg];
        [self restoreView:view];
        [self sendSubviewToBack:view];
    };
    [view pop_addAnimation:showAnimation forKey:@"hidenAnimation"];
    
}


-(void)restoreView:(UIView *)view
{
    [view.layer pop_removeAllAnimations];
    view.layer.affineTransform = CGAffineTransformIdentity;
    /*
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.2, 1.2)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    //    scaleAnimation.springBounciness = 10.f;
    scaleAnimation.duration =0;
    [view.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [view.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    */
    POPBasicAnimation *showAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    showAnimation.toValue = @(1.0);
    
    showAnimation.duration =0 ;
    [view pop_addAnimation:showAnimation forKey:@"hidenAnimation"];
    
}

-(void)fadeToggle
{
   
    if (frontShow) {

        [self scaleUpView:frontLayer];
    }
    else{

        [self scaleUpView:backGroundLayer];
    }
    
    frontShow = ! frontShow;
}
@end
