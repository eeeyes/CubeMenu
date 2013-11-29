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

typedef enum {
    ETCubeOperationLeft,
    ETCubeOperationRight,
    ETCubeOperationUp,
    ETCubeOperationDown
}ETCubeOperation;

@interface ETCubeView()
{

    UIView* _currentView;
    UIView* _nextView;
    CATransformLayer* _transformLayer;
    
    ETCubeState _cubeState;
    ETCubeOperation _cubeOperation;
    
    CGFloat lastOffset;
    
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
    
    CGPoint vectorPoint = [pan translationInView:self];
    
    
    switch (pan.state) {
        case UIGestureRecognizerStateEnded:
            if( _cubeState != ETCubeStateRunning)
                return;
            
            [self endScrollToOriginal:ABS(lastOffset)<M_PI_4];
            return;
            
        default:
            NSLog(@"began %f",vectorPoint.x);
            if(_cubeState != ETCubeStateEnd)
                break;
            if(ABS(vectorPoint.x)<2.f)
                return;
            if(vectorPoint.x<0)
                _cubeOperation = ETCubeOperationLeft;
            else
                _cubeOperation = ETCubeOperationRight;
            
            [self startSroll];
           
            break;

   }
    
    
    if( _cubeState != ETCubeStateRunning)
        return;
    
    CGFloat translationPointX = vectorPoint.x/self.bounds.size.width*M_PI;
    if (_cubeOperation == ETCubeOperationLeft &&
         (translationPointX > 0 || translationPointX < -M_PI_2 ) )
    {
      if(translationPointX > 0)
          translationPointX = 0;
      else
          translationPointX = -M_PI_2;
    }
     if  (_cubeOperation == ETCubeOperationRight &&
        (translationPointX < 0 || translationPointX > M_PI_2))
    {
       if(translationPointX<0)
           translationPointX = 0;
        else
            translationPointX = M_PI_2;
        
    }
    
    [self scrollToDegree:translationPointX];

}
-(void)startSroll
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
    if(_cubeOperation == ETCubeOperationLeft){
        transform = CATransform3DRotate(transform,  M_PI_2 , 0, 1, 0);
    }else{
        transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    }
    transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
    
    _nextView.layer.transform = transform;
    [_transformLayer addSublayer:_nextView.layer];
	[CATransaction commit];
}


-(void)endScrollToOriginal:(BOOL)toOriginal
{
    _cubeState = ETCubeStateWillEnd;
    CGFloat halfWidth = self.bounds.size.width / 2.0;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        _cubeState = ETCubeStateEnd;
        [_nextView.layer removeFromSuperlayer];
        _nextView.layer.transform = CATransform3DIdentity;
        [_currentView.layer removeFromSuperlayer];
        
        if(!toOriginal){
            UIView* tempView = _currentView;
            _currentView = _nextView;
            _nextView = tempView;
        }
        [self addSubview:_currentView];
        [_transformLayer removeFromSuperlayer];
        _transformLayer = nil;
    }];
    
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = PERSPECTIVE;
    if(!toOriginal){
        transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
        if(_cubeOperation == ETCubeOperationLeft){
            transform = CATransform3DRotate(transform, -M_PI_2 , 0, 1, 0);
        }
        else{
            transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
        }
        transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
    }
    _transformLayer.transform = transform;
    [CATransaction commit];
}

-(void)scrollToDegree:(CGFloat)degree
{
    lastOffset = degree;
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
