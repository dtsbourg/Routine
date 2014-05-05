//
//  ViewController.h
//  Routine
//
//  Created by Dylan Bourgeois on 28/04/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;


@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) AVAudioPlayer* player;
@property (strong, nonatomic) NSTimer *timer;


/* Arg to pass to artist modal view */
@property (strong, nonatomic) UIImage *artistImg;

@end
