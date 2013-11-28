//
//  ETCubeView.h
//  ETCubeMenu
//
//  Created by vcread on 13-11-27.
//  Copyright (c) 2013年 eeeyes tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETCubeView : UIView
-(void)nextPage;

-(void)startHSroll;
-(void)scrollToDegree:(CGFloat)degree;
-(void)endHScroll;

@end
