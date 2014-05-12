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
#import "Reachability.h"
#import "NZAlertView.h"

@interface ViewController ()
{
    NSString *artistText;
    float _progress;
    NSMutableArray *liked;
}
/* Arg to pass to artist modal view */
@property (strong, nonatomic) UIImage *artistImg;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *permalinkString;
    
@property (weak, nonatomic) IBOutlet TWRProgressView *progressView;

@property (strong, nonatomic) NSDate* publishDate;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /************** Fonts ****************/
    self.titleLabel.font = [UIFont fontWithName:@"CODE-Bold" size:104];
    self.artistLabel.font = [UIFont fontWithName:@"CODE-light" size:22];
    self.likeLabel.font = [UIFont fontWithName:@"CODE-light" size:17];
    
    
    /************** Progress View ****************/
    UIImage *image = [UIImage imageNamed:@"Slice 1.png"];
    [_progressView setMaskingImage:image];
    [_progressView setBackColor:[UIColor grayColor]];
    [_progressView setFrontColor:[UIColor whiteColor]];
    [_progressView setHorizontal:YES];
    _progress=0.0f;
    [_progressView setProgress:_progress];

    [self getSong];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimerTick:) userInfo:nil repeats:YES];
}

-(void)getSong
{
    /************** Backend ****************/
    PFQuery *q = [PFQuery queryWithClassName:@"Song"];
    [q whereKey:@"publishDate" lessThan:[self getTomorrow]];
    [q whereKey:@"publishDate" greaterThan:[self getYesterday]];
    [q getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
        
        /****** Get artist name ******/
        self.artistLabel.text = obj[@"artist"];
        
        /****** Get track name  ******/
        self.titleLabel.text = obj[@"title"];
        
        /****** Get artist image ******/
        PFFile*artistImage = obj[@"artistImage"];
        [artistImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                _artistImg = [UIImage imageWithData:imageData];
            }
            else
            {
                [self alert:NZAlertStyleError
                      title:@"No internet connection"
                    message:@"Please connect to the internet to enjoy your Routine !"];
            }
        }];
        
        /****** Get artist text ******/
        artistText = obj[@"artistText"];
        
        /****** Get track url ******/
        _urlString = obj[@"url"];
        
        /****** Get publish date ******/
        self.publishDate = obj[@"publishDate"];
        
        /****** Get track url ******/
        self.permalinkString = obj[@"permalink_url"];
        
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    /************* Check for new song **********/
    [self checkForNewSong];
    
    /************** Liked ****************/
    if (liked == NULL)
    liked = (NSMutableArray*)[[NSMutableArray alloc] initWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"liked"] mutableCopy] ];
    
    else if([liked containsObject:@[self.titleLabel.text, self.artistLabel.text]])
    {
        [self.likeButton setImage:[UIImage imageNamed:@"liked.png" ] forState:UIControlStateNormal];
    }
    
    /************** Reachability ****************/
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        [self alert:NZAlertStyleError
              title:@"No internet connection"
            message:@"Please connect to the internet to enjoy your Routine !"];
    };
    
    [reach startNotifier];
}

-(void)checkForNewSong
{
    NSDate*yesterday =[self getYesterday];
    
    if ([self.publishDate compare:yesterday]==NSOrderedAscending)
    {
        [self getSong];
    }
}

-(NSDate*)getTomorrow
{
    NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:units fromDate:[NSDate date]];
    comps.day++;
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

-(NSDate*)getYesterday
{
    NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:units fromDate:[NSDate date]];
    comps.day = comps.day - 2;
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
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
            
            NSURL *url   = [NSURL URLWithString:_urlString];

            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            NSError *error;
            self.player  = [[AVAudioPlayer alloc] initWithData:data error:&error];

            if (!error) {
                [self.player prepareToPlay];
                [self.player play];
                [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            }
            else
            {
                [self alert:NZAlertStyleError
                      title:@"Oops !"
                    message:@"Something went wrong, sorry about that. Please try again."];
            }

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
}

-(void)alert:(NZAlertStyle)alertStyle title:(NSString*)title message:(NSString*)message
{
    NZAlertView *alert = [[NZAlertView alloc] initWithStyle:alertStyle
                                                      title:title
                                                    message:message
                                                   delegate:nil];
    
    [alert setTextAlignment:NSTextAlignmentCenter];
    
    [alert show];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"artistSegue"])
    {
        ArtistViewController *destvc = [segue destinationViewController];
        destvc.artistLabel.text = [self.artistLabel.text uppercaseString];
        destvc.artistImage = _artistImg;
        destvc.detailText = artistText;
        destvc.urlString = self.permalinkString;
    }
}

-(IBAction)liked:(id)sender
{
    if(![liked containsObject:@[self.titleLabel.text, self.artistLabel.text]])
    {
        [liked addObject:@[self.titleLabel.text, self.artistLabel.text]];
        [[NSUserDefaults standardUserDefaults] setObject:liked forKey:@"liked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        [self.likeButton setImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateNormal];
    }
    else
    {
        [liked removeLastObject];
        [[NSUserDefaults standardUserDefaults] setObject:liked forKey:@"liked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.likeButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    }
    
}


@end
