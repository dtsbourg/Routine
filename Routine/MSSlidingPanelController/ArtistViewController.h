//
//  ArtistViewController.h
//  daily
//
//  Created by Dylan Bourgeois on 22/04/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "ViewController.h"


@interface ArtistViewController : ViewController
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *soundcloudButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIImageView *artistImageView;

@property (strong, nonatomic) IBOutlet UIButton *dismissButton;

@property (strong, nonatomic) NSString *detailText;
@property (strong, nonatomic) UIImage *artistImage;


@end
