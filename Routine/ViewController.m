//
//  ViewController.m
//  Routine
//
//  Created by Dylan Bourgeois on 28/04/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "ArtistViewController.h"

@interface ViewController ()
{
    NSString *artistText;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.progressView.progress=0.f;
    
    [self.titleLabel setVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    
    PFQuery *q = [PFQuery queryWithClassName:@"Song"];
    [q getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
        
        /****** Get background image ******/
        PFFile *userImageFile = obj[@"bgImage"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                self.bgImageView.image = [UIImage imageWithData:imageData];
            }
            else NSLog(@"%@", [error localizedDescription]);
        } progressBlock:^(NSInteger percent){NSLog(@"%i", percent);}];
        
        /****** Get artist name ******/
        self.artistLabel.text = obj[@"artist"];
        
        /****** Get track name  ******/
        self.titleLabel.text = obj[@"title"];
        
        /****** Get artist image ******/
        PFFile*artistImage = obj[@"artistImage"];
        [artistImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                self.artistImg = [UIImage imageWithData:imageData];
            }
            else NSLog(@"%@", [error localizedDescription]);}];
        
        /****** Get artist text ******/
        artistText = obj[@"artistText"];
        NSLog(@"%@", artistText);

        
    }];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)playSong {
    
    if ([self.player isPlaying])
        [self.player pause];
    else {
        if (self.player == nil) {
            NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/137851436/stream?client_id=81bd906c1a1de7e015331c6942633a48"];

            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            NSError *error;
            self.player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    
            if (!error) {
                [self.player prepareToPlay];
                [self.player play];
            }
            else NSLog(@"%@", error);
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"artistSegue"])
    {
        ArtistViewController *destvc = [segue destinationViewController];
        destvc.artistLabel.text = [self.artistLabel.text uppercaseString];
        destvc.artistImage = self.artistImg;
        destvc.detailText = artistText;
        
    }
}
@end
