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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _cubeView = [[ETCubeView alloc]init];
    
    
    [self.view addSubview:_cubeView];

}
-(void)viewWillAppear:(BOOL)animated
{
    _cubeView.frame = CGRectMake(60.f, 100.f, 200.f, 200.f);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
