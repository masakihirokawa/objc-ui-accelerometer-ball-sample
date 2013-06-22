//
//  ViewController.m
//  UIAccelerometerBallSample
//
//  Created by Dolice on 2013/06/22.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import "ViewController.h"

#pragma mark private methods definition

@interface ViewController ()
- (CGFloat)lowpassFilter:(CGFloat)accel before:(CGFloat)before;
- (CGFloat)highpassFilter:(CGFloat)accel before:(CGFloat)before;
@end

#pragma mark start implementation for methods

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //背景色を白に指定
    self.view.backgroundColor = [UIColor whiteColor];
    
    //UIImageView追加
    UIImage* image = [UIImage imageNamed:@"ball.png"];
    imageView_ = [[UIImageView alloc] initWithImage:image];
    imageView_.center = self.view.center;
    imageView_.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:imageView_];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //加速度センサーからの値取得開始
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 1.0 / 60.0;
    accelerometer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    speedX_ = speedY_ = 0.0;
    
    //加速度センサーからの値取得終了
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = nil;
}

//加速度センサーからの通知
- (void)accelerometer:(UIAccelerometer *)accelerometer
        didAccelerate:(UIAcceleration *)acceleration
{
    speedX_ += acceleration.x;
    speedY_ += acceleration.y;
    CGFloat posX = imageView_.center.x + speedX_;
    CGFloat posY = imageView_.center.y - speedY_;
    
    //端にあたったら跳ね返る処理
    if (posX < 0.0) {
        posX = 0.0;
        
        //左の壁にあたったら0.4倍の力で跳ね返る
        speedX_ *= -0.4;
    } else if (posX > self.view.bounds.size.width) {
        posX = self.view.bounds.size.width;
        
        //右の壁にあたったら0.4倍の力で跳ね返る
        speedX_ *= -0.4;
    }
    if (posY < 0.0) {
        posY = 0.0;
        
        //上の壁にあたっても跳ね返らない
        speedY_ = 0.0;
    } else if (posY > self.view.bounds.size.height) {
        posY = self.view.bounds.size.height;
        
        //下の壁にあたったら1.5倍の力で跳ね返る
        speedY_ *= -1.5;
    }
    imageView_.center = CGPointMake(posX, posY);
}

//ローパスフィルタ
- (CGFloat)lowpassFilter:(CGFloat)accel before:(CGFloat)before
{
    static const CGFloat kFilteringFactor = 0.1;
    return (accel * kFilteringFactor) + (before * (1.0 - kFilteringFactor));
}

//ハイパスフィルタ
- (CGFloat)highpassFilter:(CGFloat)accel before:(CGFloat)before
{
    return (accel - [self lowpassFilter:accel before:before]);
}

@end
