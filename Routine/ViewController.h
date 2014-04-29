//
//  ViewController.h
//  Routine
//
//  Created by Dylan Bourgeois on 28/04/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VALabel.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet VALabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;

@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) AVAudioPlayer* player;
@property (strong, nonatomic) NSTimer *timer;

/* Arg to pass to artist modal view */
@property (strong, nonatomic) UIImage *artistImg;

@end
