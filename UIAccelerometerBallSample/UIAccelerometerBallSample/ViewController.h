//
//  ViewController.h
//  UIAccelerometerBallSample
//
//  Created by Dolice on 2013/06/22.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import <UIKit/UIKit.h>

//UIAccelerometerからの通知を受けるため UIAccelerometerDelegateプロトコルを実装
@interface ViewController : UIViewController <UIAccelerometerDelegate> {
@private
    UIImageView* imageView_;
    UIAccelerationValue speedX_;
    UIAccelerationValue speedY_;
}

@end
