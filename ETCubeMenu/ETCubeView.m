//
//  ETCubeView.m
//  ETCubeMenu
//
//  Created by vcread on 13-11-27.
//  Copyright (c) 2013年 eeeyes tech. All rights reserved.
//

#import "ETCubeView.h"
#import <QuartzCore/QuartzCore.h>

#define PERSPECTIVE (-1.0/500.0)
typedef enum
{
    ETCubeStateRunning,
    ETCubeStateWillEnd,
    ETCubeStateEnd
} ETCubeState;
@interface ETCubeView()
{

    UIView* _currentView;
    UIView* _nextView;
    CATransformLayer* _transformLayer;
    
    ETCubeState _cubeState;
    
}
-(void)moved:(UIPanGestureRecognizer*)pan;
@end

@implementation ETCubeView

- (id)init
{
    self = [super init];
    if( self ){
        
        _cubeState = ETCubeStateEnd;
        
        self.backgroundColor = [UIColor blueColor];
        
        UILabel* textLabel = [[UILabel alloc]init];
        
        [self addSubview:textLabel];
        textLabel.frame = self.bounds;
        textLabel.backgroundColor = [UIColor greenColor];
        textLabel.text = @"A";
        textLabel.font = [UIFont systemFontOfSize:50.f];
        textLabel.textAlignment = NSTextAlignmentCenter;

        
        _currentView = textLabel;
        
        textLabel = [[UILabel alloc]init];
        textLabel.backgroundColor = [UIColor yellowColor];
        textLabel.text = @"B";
        textLabel.font = [UIFont systemFontOfSize:50.f];
        textLabel.textAlignment = NSTextAlignmentCenter;
        
        _nextView = textLabel;
        
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moved:)];
        pan.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:pan];
        
        
        
      
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)moved:(UIPanGestureRecognizer *)pan
{
    if( _cubeState == ETCubeStateWillEnd )
        return;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            if(_cubeState == ETCubeStateRunning )
                return;
            [self startHSroll];
            break;
        case UIGestureRecognizerStateEnded:
            if( _cubeState != ETCubeStateRunning)
                return;
            [self endHScroll];
            return;
        default:
            break;
   }
    
    CGFloat translationPointX = -ABS([pan translationInView:self].x)/self.bounds.size.width*M_PI;
    if( translationPointX < -M_PI_2){
        [self endHScroll];
    }
    else
        [self scrollToDegree:translationPointX];

}
-(void)startHSroll
{
    _cubeState = ETCubeStateRunning;
    CGFloat halfWidth = self.bounds.size.width / 2.0;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    //add currentview and nextview transform layer
    _transformLayer = [[CATransformLayer alloc] init];
	_transformLayer.frame = self.layer.bounds;
    
    [_currentView removeFromSuperview];
    [_transformLayer addSublayer:_currentView.layer];
    [_transformLayer addSublayer:_nextView.layer];
    [self.layer addSublayer:_transformLayer];
    
    
    //cube the next view
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
    transform = CATransform3DRotate(transform,  M_PI_2 , 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
    _nextView.layer.transform = transform;
    [_transformLayer addSublayer:_nextView.layer];
	[CATransaction commit];
}
-(void)endHScroll
{
    _cubeState = ETCubeStateWillEnd;
    CGFloat halfWidth = self.bounds.size.width / 2.0;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        _cubeState = ETCubeStateEnd;
        [_nextView.layer removeFromSuperlayer];
        _nextView.layer.transform = CATransform3DIdentity;
        [_currentView.layer removeFromSuperlayer];
        
        UIView* tempView = _currentView;
        _currentView = _nextView;
        _nextView = tempView;
        
        [self addSubview:_currentView];
        [_transformLayer removeFromSuperlayer];
        _transformLayer = nil;
    }];
    
    
    CATransform3D transform = CATransform3DIdentity;
	transform.m34 = PERSPECTIVE;
    transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
    transform = CATransform3DRotate(transform, -M_PI_2 , 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
    _transformLayer.transform = transform;
    [CATransaction commit];
}
-(void)scrollToDegree:(CGFloat)degree
{
    CGFloat halfWidth = self.bounds.size.width / 2.0;
   
    CATransform3D transform = CATransform3DIdentity;
	transform.m34 = PERSPECTIVE;
    transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
    transform = CATransform3DRotate(transform, degree , 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
    

    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _transformLayer.transform = transform;
    [CATransaction commit];
    
}
-(void)nextPage
{
    CGFloat halfWidth = self.bounds.size.width / 2.0;
     CGFloat perspective = -1.0/1000.0;
    
    //add currentview and nextview transform layer
    CALayer *transformLayer = [[CATransformLayer alloc] init];
	transformLayer.frame = self.layer.bounds;
    
    [_currentView removeFromSuperview];
    [transformLayer addSublayer:_currentView.layer];
    [transformLayer addSublayer:_nextView.layer];
    [self.layer addSublayer:transformLayer];
    
    
    //cube the next view
    [CATransaction begin];
	[CATransaction setDisableActions:YES];
	CATransform3D transform = CATransform3DIdentity;
	
	
    transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
    transform = CATransform3DRotate(transform,  M_PI_2 , 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
  
	
	_nextView.layer.transform = transform;
	[CATransaction commit];
    
    //animated rotate the next view
    CGFloat duration = .7f;
   
    
    [CATransaction begin];
	[CATransaction setCompletionBlock:^(void) {
		[_nextView.layer removeFromSuperlayer];
		_nextView.layer.transform = CATransform3DIdentity;
		[_currentView.layer removeFromSuperlayer];
        
		UIView* tempView = _currentView;
        _currentView = _nextView;
        _nextView = tempView;
        
		[self addSubview:_currentView];
		[transformLayer removeFromSuperlayer];
		
		
	}];
	
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	
	transform = CATransform3DIdentity;
	transform.m34 = perspective;
	transformAnimation.fromValue = [NSValue valueWithCATransform3D:transform];
	
	transform = CATransform3DIdentity;
	transform.m34 = perspective;
    transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
    transform = CATransform3DRotate(transform, -M_PI_2 , 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
    
	transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
	
	transformAnimation.duration = duration;
	
	[transformLayer addAnimation:transformAnimation forKey:@"rotate"];
	transformLayer.transform = transform;
	
	[CATransaction commit];

}
-(void)layoutSubviews
{
    if(CGRectEqualToRect(_currentView.frame, self.bounds))
        return;
    [super layoutSubviews];
    _currentView.frame = self.bounds;
    _nextView.frame = self.bounds;
    _transformLayer.frame = self.bounds;

}

@end
