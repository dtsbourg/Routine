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
#import "TWRProgressView.h"

@interface ViewController ()
{
    NSString *artistText;
    float _progress;
    NSMutableArray *liked;
}
    
@property (weak, nonatomic) IBOutlet TWRProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    self.titleLabel.font = [UIFont fontWithName:@"CODE-Bold" size:104];
    self.artistLabel.font = [UIFont fontWithName:@"CODE-light" size:22];
    self.likeLabel.font = [UIFont fontWithName:@"CODE-light" size:17];
    
    
    UIImage *image = [UIImage imageNamed:@"Slice 1.png"];
    [_progressView setMaskingImage:image];
    [_progressView setBackColor:[UIColor grayColor]];
    [_progressView setFrontColor:[UIColor whiteColor]];
    [_progressView setHorizontal:YES];
    // Sync initial slider and image starting progress...
    _progress=0.0f;
    [_progressView setProgress:_progress];

    
    PFQuery *q = [PFQuery queryWithClassName:@"Song"];
    [q getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
        
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
        
    }];
    
     [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimerTick:) userInfo:nil repeats:YES];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    if (liked == NULL)
    liked = (NSMutableArray*)[[NSMutableArray alloc] initWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"liked"] mutableCopy] ];
    
    else if([liked containsObject:@[self.titleLabel.text, self.artistLabel.text]])
    {
        [self.likeButton setImage:[UIImage imageNamed:@"liked.png" ] forState:UIControlStateNormal];
    }

}

- (void)onTimerTick:(id)sender {
    if (![self.player isPlaying]) {
        return;
    }
    
    NSTimeInterval totalTime = [self.player duration];
    NSTimeInterval currentTime = [self.player currentTime];
    _progress = currentTime / totalTime;
    [self.progressView setProgress:_progress];
}

-(IBAction)playSong {
 
    if ([self.player isPlaying]) {
        [self.player pause];
        [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }

    else {
        if (self.player == nil) {
            
            NSURL *url   = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/137851436/stream?client_id=81bd906c1a1de7e015331c6942633a48"];

            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            NSError *error;
            self.player  = [[AVAudioPlayer alloc] initWithData:data error:&error];

            if (!error) {
                [self.player prepareToPlay];
                [self.player play];
                [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            }
            else NSLog(@"%@", error);

        }
        else{
            [self.player play];
            [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
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

-(IBAction)liked:(id)sender
{
    if(![liked containsObject:@[self.titleLabel.text, self.artistLabel.text]])
    {
        [liked addObject:@[self.titleLabel.text, self.artistLabel.text]];
        [[NSUserDefaults standardUserDefaults] setObject:liked forKey:@"liked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        [self.likeButton setImage:[UIImage imageNamed:@"liked.png" ] forState:UIControlStateNormal];
    }
    else
    {
        [liked removeLastObject];
        [[NSUserDefaults standardUserDefaults] setObject:liked forKey:@"liked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.likeButton setImage:[UIImage imageNamed:@"heart.png" ] forState:UIControlStateNormal];
    }
    
}

@end
