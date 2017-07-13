//
//  SerieDetailViewController.m
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 5/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import "SerieDetailViewController.h"
#import "WebViewController.h"

@interface SerieDetailViewController ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *seasonsLabel;
@property (weak, nonatomic) IBOutlet UILabel *episodesLabel;
@property (weak, nonatomic) IBOutlet UILabel *productionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productionImageView;
@property (weak, nonatomic) IBOutlet UILabel *votesLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoDescTextView;

@property (weak, nonatomic) IBOutlet UIImageView *dropbackImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundViewGradient;



- (IBAction)infoWebButtonPressed:(id)sender;

@end

@implementation SerieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.aModel.title;


}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.backgroundViewGradient.bounds;
    UIColor *firstColor = (id)[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f].CGColor;
    UIColor *secondColor = (id)[UIColor colorWithRed:0.27f green:0.67f blue:0.38f alpha:1.0f].CGColor;

    gradient.colors = @[ firstColor, secondColor ];
    
    [self.backgroundViewGradient.layer insertSublayer:gradient atIndex:0];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size
          withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [[[self.backgroundViewGradient.layer sublayers] objectAtIndex:0] setFrame:self.backgroundViewGradient.bounds];

    }];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self syncModelWithView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//#pragma mark - Segues
//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    if ([segue.identifier isEqualToString:@"webSegue"]) {
//        
//        WebViewController *destination = (WebViewController *) [segue destinationViewController];
//        destination.webURL = self.aModel.infoWeb;
//        
//        destination.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        self.navigationItem.leftItemsSupplementBackButton = true;
//    }
//}



#pragma mark - Utils
-(void) syncModelWithView {
    
    self.titleLabel.text = self.aModel.title;
    self.genreLabel.text = [self arrayToString: self.aModel.genres];
    self.seasonsLabel.text = [NSString stringWithFormat:@"Seasons: %d   ",self.aModel.seasons];
    self.episodesLabel.text = [NSString stringWithFormat:@"Episodes: %d   ",self.aModel.episodes];
    self.productionLabel.text = [NSString stringWithFormat:@"Actually in production:    "];
    // mostrar check si esta en produccion o aspas si no
    
    NSLog(@"%@",self.aModel.inProduction ? @"YES":@"NO");
    
    if(!self.aModel.inProduction){
        self.productionImageView.image = [UIImage imageNamed:@"icon-Cancel.png"];
    } else {
        self.productionImageView.image = [UIImage imageNamed:@"icon-Ok.png"];
    }
    
    self.votesLabel.text = [NSString stringWithFormat:@"Votes (%d)   ",self.aModel.votesCount];
    // mostrar la media de votos con estrellas
    
    self.infoDescTextView.text = self.aModel.infoDesc;
    self.coverImageView.image = self.aModel.cover;
    self.dropbackImageView.image = self.aModel.backdrop;
    
    // otras configuraciones
    self.infoDescTextView.textAlignment = NSTextAlignmentJustified;
}


-(NSString *) arrayToString:(NSArray *) arrayGenres{
    
    NSString *result = nil;
    
    if ([arrayGenres count] == 1) {
        result = [@"Genre: " stringByAppendingString:[arrayGenres lastObject]];
    } else if ([arrayGenres count] > 1){
        result = [[@"Genres: " stringByAppendingString:[arrayGenres componentsJoinedByString:@", "]] stringByAppendingString:@"."];
    } else {
        result = @"Genres: no defined.";
    }
    
    return result;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)infoWebButtonPressed:(id)sender {
    // Lanzamos una escena manual
    
    WebViewController *destination  = (WebViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"webSerieScene"];
    
    destination.webURL = self.aModel.infoWeb;
    
    // transicion SHOW, tenemos que tirar del navigationController en el que estamos
    [self.navigationController pushViewController:destination animated:YES];
    
}
@end
