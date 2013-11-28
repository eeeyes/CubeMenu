//
//  ETCubeViewController.m
//  ETCubeMenu
//
//  Created by vcread on 13-11-27.
//  Copyright (c) 2013年 eeeyes tech. All rights reserved.
//

#import "ETCubeViewController.h"
#import "ETCubeView.h"

@interface ETCubeViewController ()
{
    ETCubeView* _cubeView;
    UIButton* _nextButton;
}
@end

@implementation ETCubeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor redColor];
    }
    return self;
}
-(void)next
{
    [_cubeView nextPage];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _cubeView = [[ETCubeView alloc]init];
    
    
    _nextButton = [[UIButton alloc]init];
    _nextButton.backgroundColor = [UIColor purpleColor];
    
    [_nextButton setTitle:@"next" forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_cubeView];
    [self.view addSubview:_nextButton];
}
-(void)viewWillAppear:(BOOL)animated
{
    _cubeView.frame = CGRectMake(60.f, 100.f, 200.f, 200.f);
    _nextButton.frame = CGRectMake(60.f, 400.f, 200.f, 60.f);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
