//
//  tictactoe.m
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-02.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import "tictactoe_game.h"
#import "TicTacToe.h"

@interface tictactoe_game ()

@end



@implementation tictactoe_game {
    
    
    IBOutlet UIButton *tttA1;
    IBOutlet UIButton *tttB1;
    IBOutlet UIButton *tttC1;
    IBOutlet UIButton *tttA2;
    IBOutlet UIButton *tttB2;
    IBOutlet UIButton *tttC2;
    IBOutlet UIButton *tttA3;
    IBOutlet UIButton *tttB3;
    IBOutlet UIButton *tttC3;
    
    IBOutlet UILabel *usercounter;
    IBOutlet UILabel *computercounter;
    IBOutlet UILabel *drawcounter;
    IBOutlet UILabel *streakcount;
    IBOutlet UILabel *txtTitle;
}

    int drawcount;
    int youcounter;
    int computercount;
    int iconimage; // what icon is the user playing with
    int thestreak; //used for achievements - get 10 wins in a row!





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
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.243 green:0.125 blue:0.345 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:30.0];
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Tic Tac Toe", @"");
    [label sizeToFit];
    
    drawcount = 0;
    youcounter = 0;
    computercount = 0;
    iconimage = 0;
    thestreak = 0;
    ttt = [ [ TicTacToe alloc ] init ];
    
    /* this works txtTitle.text =@"hi mom";
    UIImage *testme;
    testme = [  UIImage imageNamed:@"o.png" ];
    [tttB1 setImage:testme forState:UIControlStateNormal];
   */ 
    
}

- (IBAction)clickAction:(id)sender {
    
   //  NSLog(@"You clicked on image with tag: %d", (int)[ sender tag ]);
    NSString* tttImageFileName;
    NSInteger row, col;
    UIImage *tttImage;
    
    row = ([ sender tag ] % 10) - 1;
    col = (int)([ sender tag ] / 10) - 1;
    
    @try
    {
        [ ttt makeMoveAtColumn: col andRow: row ];
    }
    @catch (NSException *ex)
    {
        // NSLog(@"ERROR: %@", [ ex reason ]);
       // NSRunAlertPanel(@"ooops", [ ex reason ], @"Try again", nil, nil);
        return;
    }
    
    if( [ ttt whoseTurn ] != 'X' )
    {
        //tttImageFileName = [ [ NSBundle mainBundle ] pathForResource: @"x" ofType: @"png" ];
        tttImageFileName = @"x.png";
    }
    else
    {
        //tttImageFileName = [ [ NSBundle mainBundle ] pathForResource: @"o" ofType: @"png" ];
        tttImageFileName = @"o.png";
    }
 
    tttImage = [  UIImage imageNamed:tttImageFileName ];
    [ sender setImage:tttImage forState:UIControlStateNormal];
    
    if( [ ttt whoIsWinner ] == 'X' )
    {
        //    NSLog(@"The winner is player one (not the computer)!");
        youcounter++;
        thestreak++;
        int percenttoreport = thestreak*10;
        [self reportAchievementIdentifier:@"10wins" percentComplete:percenttoreport ];
        // NSLog (@"just reported the streak!");
        usercounter.text = [NSString stringWithFormat:@"%i", youcounter];
        streakcount.text = [NSString stringWithFormat:@"%i", thestreak];
      //  NSRunAlertPanel(@"Game Over", @"You win!", @"Play again", nil, nil);
        // NSLog(@"get here?");
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                          message:@"You win!!"
                                                         delegate:nil
                                                cancelButtonTitle:@"Play Again"
                                                otherButtonTitles:nil];
        [message show];
        GKScore *scorereport = [[GKScore alloc] initWithCategory:@"Victories"];
        scorereport.value = youcounter;
        scorereport.context = 0;
        [scorereport reportScoreWithCompletionHandler:^(NSError *error) {
            //nah}
        }];
        
        [ self resetBoard ];
    }
    else if( [ ttt whoIsWinner ] == 'O' )
    {
        
        computercount++;
        thestreak=0;
        streakcount.text = [NSString stringWithFormat:@"%i", thestreak];
        computercounter.text = [NSString stringWithFormat:@"%i", computercount];
        //NSRunAlertPanel(@"Game Over", @"You lose!", @"Play again", nil, nil);
        [ self resetBoard ];
    }
    else if( [ ttt whoIsWinner ] == 'D' )
    {
        //   NSLog(@"DRAW!");
       // NSRunAlertPanel(@"Game Over", @"DRAW!", @"Play again", nil, nil);
        [ self resetBoard ];
        drawcount++;
        thestreak=0;
        streakcount.text = [NSString stringWithFormat:@"%i", thestreak];
        drawcounter.text = [NSString stringWithFormat:@"%i", drawcount];
        
    }
    else
    {
        if( [ ttt whoseTurn ] == 'X')
        {
            txtTitle.text =  @"Your turn" ;
            
        }
        else
        {
            
            // NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 1.5 ];  // a simple pause for1.5 seconds
            txtTitle.text = @"My turn" ;
            // [NSThread sleepUntilDate:future];
            //NSLog(@"hi-myto");
            [self runcomputerturn];
            
        }
    }
    
}


-(void) runcomputerturn {
    
    NSString* tttImageFileName = nil;
    UIImage *tttImage = nil;
    NSInteger row = 0 + arc4random() %(3) ;
    NSInteger col = 0 + arc4random() %(3) ;
    //[ txtTitle setStringValue: @"My turn" ];
    //  usleep(1000000);// would sleep 1/10 second.
    //  NSLog (@"Row %i Col %i", row, col);
    
    @try
    {
        
        [ ttt makeMoveAtColumn: col andRow: row ];
        
    }
    @catch (NSException *ex)
    {
        // NSLog(@"ERROR: %@", [ ex reason ]);
        // NSRunAlertPanel(@"ooops", [ ex reason ], @"Try again", nil, nil);
        [self runcomputerturn];
        return;
    }
    if( [ ttt whoseTurn ] != 'X' )
        tttImageFileName = @"x.png";
    else
        tttImageFileName = @"o.png";
    
    tttImage = [  UIImage imageNamed:tttImageFileName ];
    
    
    
    if ((row ==0 ) && (col ==0)){
        
        [tttA1 setImage:tttImage forState:UIControlStateNormal];
        
    }
    if ((row ==0 ) && (col ==1)){
        
        [tttB1 setImage:tttImage forState:UIControlStateNormal];
    }
    if ((row ==0 ) && (col ==2)){
        
        [tttC1 setImage:tttImage forState:UIControlStateNormal];
    }
    if ((row ==1 ) && (col ==0)){
        
        [tttA2 setImage: tttImage forState:UIControlStateNormal];
    }
    if ((row ==1 ) && (col ==1)){
        
        [tttB2 setImage: tttImage forState:UIControlStateNormal];
    }
    if ((row ==1 ) && (col ==2)){
        
        [tttC2 setImage: tttImage forState:UIControlStateNormal];
    }
    if ((row ==2 ) && (col ==0)){
        
        [tttA3 setImage: tttImage forState:UIControlStateNormal];
    }
    if ((row ==2 ) && (col ==1)){
        
        [tttB3 setImage: tttImage forState:UIControlStateNormal];
    }
    if ((row ==2 ) && (col ==2)){
        
        [tttC3 setImage: tttImage forState:UIControlStateNormal];
    }
    
    
    if( [ ttt whoIsWinner ] == 'X' )
    {
        //    NSLog(@"The winner is player one (not the computer)!");
        
        
        youcounter++;
        thestreak++;
        streakcount.text = [NSString stringWithFormat:@"%i", thestreak];
        usercounter.text = [NSString stringWithFormat:@"%i", youcounter];
       // NSRunAlertPanel(@"Game Over", @"You win!!!", @"Play again", nil, nil);
        
        [ self resetBoard ];
    }
    else if( [ ttt whoIsWinner ] == 'O' )
    {
        thestreak=0;
        computercount++;
        computercounter.text  = [NSString stringWithFormat:@"%i", computercount];
        streakcount.text = [NSString stringWithFormat:@"%i", thestreak];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                          message:@"You lose!!"
                                                         delegate:nil
                                                cancelButtonTitle:@"Play Again"
                                                otherButtonTitles:nil];
        [message show];
        // NSRunAlertPanel(@"Game Over", @"You lose!!", @"Play again", nil, nil);
        [ self resetBoard ];
    }
    else if( [ ttt whoIsWinner ] == 'D' )
    {
        //   NSLog(@"DRAW!");
     //   NSRunAlertPanel(@"Game Over", @"DRAW!", @"Play again", nil, nil);
        [ self resetBoard ];
        thestreak=0;
        drawcount++;
        streakcount.text = [NSString stringWithFormat:@"%i", thestreak];
        drawcounter.text = [NSString stringWithFormat:@"%i", drawcount];
        
    }
    else
    {
        if( [ ttt whoseTurn ] == 'X')
        {
            
            // NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 1.5 ];  // a simple pause for1.5 seconds
             txtTitle.text = @"Your turn" ;
            //[NSThread sleepUntilDate:future];
            //            NSLog(@"hi-yourt");
        }
        else
        {
            txtTitle.text = @"My turn" ;
            //  NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 1.5 ];  // a simple pause for1.5 seconds
            //  [NSThread sleepUntilDate:future];
            //  NSLog(@"hi-myt");
            [self runcomputerturn];
            
        }
    }
    
    
    
    
    
}

- (void) resetBoard {
    txtTitle.text =  @"You go first" ;

    //NSString* blankFileName = [ [ NSBundle mainBundle ] pathForResource:@"blank" ofType:@"png" ];
    NSString* blankFileName =@"blank.png";
    UIImage* blankImage = [ UIImage imageNamed:blankFileName ];
    //  NSLog(@"image name: %@", blankFileName);
    [ tttA1 setImage:blankImage forState:UIControlStateNormal];
    [ tttA2 setImage:blankImage forState:UIControlStateNormal];
    [ tttA3 setImage:blankImage forState:UIControlStateNormal];
    [ tttB1 setImage:blankImage forState:UIControlStateNormal ];
    [ tttB2 setImage:blankImage forState:UIControlStateNormal];
    [ tttB3 setImage:blankImage forState:UIControlStateNormal];
    [ tttC1 setImage:blankImage forState:UIControlStateNormal];
    [ tttC2 setImage:blankImage forState:UIControlStateNormal];
    [ tttC3 setImage:blankImage forState:UIControlStateNormal];
    
    [ ttt reset ];
    
}


- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete:
(float) percent
{
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:
                                  identifier];
    if (achievement)
    {
        achievement.percentComplete = percent;
        achievement.showsCompletionBanner = YES;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (error != nil)
             {
                 NSLog(@"Error in reporting achievements: %@", error);
             }
         }];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
