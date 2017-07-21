//
//  SerieDetailViewController.m
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 5/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import "SerieDetailViewController.h"
#import "WebViewController.h"
#import <FontAwesomeKit.h>

@interface SerieDetailViewController ()

@property (nonatomic, strong) NSURLSessionDataTask *imageDataTaskForCover;
@property (nonatomic, strong) NSURLSessionDataTask *imageDataTaskForBackDrop;

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

@property (weak, nonatomic) IBOutlet UIButton *infoWebButton;

- (IBAction)infoWebButtonPressed:(id)sender;

@end

@implementation SerieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.aModel.title;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    // creamos una capa nueva de la vista para poder mostrar un degradado de fondo
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.backgroundViewGradient.bounds;
    UIColor *firstColor = (id)[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f].CGColor;
    UIColor *secondColor = (id)[UIColor colorWithRed:0.27f green:0.67f blue:0.38f alpha:1.0f].CGColor;
    
    gradient.colors = @[ firstColor, secondColor ];
    
    [self.backgroundViewGradient.layer insertSublayer:gradient atIndex:0];
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    // para recalcular el tamaño de la capa de degradado en caso de girar el dispositivo
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
    
    if(![self.aModel.infoWeb.scheme hasPrefix:@"http"]){
        self.infoWebButton.hidden = YES;
    }
    
    self.genreLabel.text = [self.genreLabel.text stringByAppendingString:[self arrayToString: self.aModel.genres]];
    self.seasonsLabel.text = [self.seasonsLabel.text stringByAppendingString:[NSString stringWithFormat:@"%d",self.aModel.seasons]];
    self.episodesLabel.text = [self.episodesLabel.text stringByAppendingString:[NSString stringWithFormat:@"%d",self.aModel.episodes]];
    
    // mostrar check si esta en produccion o aspas si no
    NSLog(@"%@",self.aModel.inProduction ? @"YES":@"NO");
    
    if(!self.aModel.inProduction){
        self.productionImageView.image = [UIImage imageNamed:@"icon-Cancel.png"];
    } else {
        self.productionImageView.image = [UIImage imageNamed:@"icon-Ok.png"];
    }
    

    if ([self.votesLabel.text length] <= 6){
        
        // mostrar la media de votos con estrellas
        // creamos icono para mostrar los votos
        
        NSMutableArray *starIconsArray = [NSMutableArray array];
        
        for (int i = 0; i < self.aModel.votesAverage; i++){
            NSError *error;
            FAKFontAwesome *starIcon = [FAKFontAwesome  iconWithIdentifier:@"fa-star" size:15 error:&error];
            UIColor *buttonColor = (id)[UIColor colorWithRed:1.0f green:0.82f blue:0.22f alpha:1.0f];
            [starIcon addAttribute:NSForegroundColorAttributeName value:buttonColor];
            
            starIcon.drawingPositionAdjustment = UIOffsetMake(i * -(starIcon.iconFontSize), starIcon.iconFontSize * 0.4);
            
            [starIconsArray addObject:starIcon];
        }
        
        NSLog(@"Tengo: %lu", (unsigned long)starIconsArray.count);
        
        UIImage *finalImageStars = [UIImage imageWithStackedIcons:starIconsArray imageSize:CGSizeMake(350, 25)];
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = finalImageStars;
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        NSString *textVotes = [self.votesLabel.text stringByAppendingString:[NSString stringWithFormat:@"(%d)",self.aModel.votesCount]];
        
        NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] initWithString:textVotes];
        [finalString appendAttributedString:attachmentString];
        
        self.votesLabel.attributedText = finalString;
        
    }
    
    
    
    self.infoDescTextView.text = self.aModel.infoDesc;

    self.coverImageView.image = [UIImage imageNamed:@"load-image.png"];
    self.dropbackImageView.image = [UIImage imageNamed:@"load-image.png"];
    
    [self showCoverImageFromURL:self.aModel.coverURL];
    [self showDropBackImageFromURL:self.aModel.backdropURL];
    
    // otras configuraciones
    self.infoDescTextView.textAlignment = NSTextAlignmentJustified;
}

-(void) showCoverImageFromURL:(NSURL *) imageURL{
    
    if (self.imageDataTaskForCover != nil) {
        [self.imageDataTaskForCover cancel];
        self.imageDataTaskForCover = nil;
    }
    
    self.imageDataTaskForCover = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error==nil){
            UIImage *image = [UIImage imageWithData:data];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.coverImageView.image = image;
            }];
        }
        
        self.imageDataTaskForCover = nil;
    }];
    
    [self.imageDataTaskForCover resume];
}

-(void) showDropBackImageFromURL:(NSURL *) imageURL{
    
    if (self.imageDataTaskForBackDrop != nil) {
        [self.imageDataTaskForBackDrop cancel];
        self.imageDataTaskForBackDrop = nil;
    }
    
    self.imageDataTaskForBackDrop = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error==nil){
            UIImage *image = [UIImage imageWithData:data];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.dropbackImageView.image = image;
            }];
        }
        
        self.imageDataTaskForBackDrop = nil;
    }];
    
    [self.imageDataTaskForBackDrop resume];
}

-(NSString *) arrayToString:(NSArray *) arrayGenres{
    
    NSString *result = nil;
    
    if ([arrayGenres count] == 1) {
        result = [[arrayGenres lastObject] stringByAppendingString:@"."];
    } else if ([arrayGenres count] > 1){
        result = [[arrayGenres componentsJoinedByString:@", "] stringByAppendingString:@"."];
    } else {
        result = @"no defined.";
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
