//
//  ArtistViewController.m
//  daily
//
//  Created by Dylan Bourgeois on 22/04/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "ArtistViewController.h"
#import <Social/Social.h>

@interface ArtistViewController ()

@end

@implementation ArtistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initGraphics];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initGraphics
{
    self.detailLabel.font = [UIFont fontWithName:@"CODE-Light" size:30];
    self.detailLabel.text = self.detailText;
    
    self.artistImageView.layer.cornerRadius = 120;
    self.artistImageView.layer.masksToBounds = YES;
    self.artistImageView.layer.borderWidth = 3;
    
    CGColorRef white = [[UIColor colorWithWhite:1.0 alpha:1] CGColor];
    self.artistImageView.layer.borderColor = white;
    self.artistImageView.image = self.artistImage;
}

-(IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)shareToFacebook:(id)sender
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController* fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbSheet setInitialText:@"Check out this awesome song I discovered on Routine !"];
        [fbSheet addURL:[NSURL URLWithString:self.urlString]];
        [self presentViewController:fbSheet animated:YES completion:nil];
    }
}

-(IBAction)shareToTwitter:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController* tweetsheet= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetsheet setInitialText:[NSString stringWithFormat:@"Check this awesome song I discovered on @routineapp: %@", self.urlString]];
        [self presentViewController:tweetsheet animated:YES completion:nil];
    }
}

@end
