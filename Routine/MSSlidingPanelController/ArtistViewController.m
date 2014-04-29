//
//  ArtistViewController.m
//  daily
//
//  Created by Dylan Bourgeois on 22/04/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "ArtistViewController.h"

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
    self.detailLabel.text = self.detailText;
    self.artistImageView.image = self.artistImage;
    
    self.detailLabel.numberOfLines = 0;
    [self.detailLabel sizeToFit];
    [self.detailLabel setVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
