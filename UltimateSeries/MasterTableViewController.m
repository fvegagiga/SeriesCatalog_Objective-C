//
//  MasterTableViewController.m
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 7/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import "MasterTableViewController.h"
#import "standarTableViewCell.h"
#import "SerieDetailViewController.h"
#import <CRGradientNavigationBar.h>

#define IS_IPHONE UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone

@interface MasterTableViewController ()

@property (strong, nonatomic) SerieModel *aModel;
@property (assign, nonatomic) int actualRow;
@property (assign, nonatomic) int totalPages;

@property (nonatomic) BOOL activeSearch;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end


@implementation MasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.seriesArray = [NSMutableArray array];
    self.searchArray = [NSMutableArray array];
    
    self.actualRow = 0;
    
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAutomatic;
    
    // inicializamos el modelo de datos:
    //          - tabla de la escena Master;
    //          - escena Detail con la información del primer registro
    self.totalPages = 20;
    for (int i = 1; i < self.totalPages; i++){
        [self getMasterTableDataFromURL:i];
    }
    
    // Configuración de la barra de navegación de la escena MASTER
    //UINavigationController *navControllerMaster = self.splitViewController.viewControllers[0];
    
    // Configuración de la barra de navegación de la escena DETAIL
    UINavigationController *navControllerDetail = self.splitViewController.viewControllers[1];
    
    SerieDetailViewController *rootDetailViewController = (SerieDetailViewController*)navControllerDetail.topViewController;
    rootDetailViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = true;
    
    
    // establecemos el color de degradado para las barras de navegación
    UIColor *firstColor = [UIColor colorWithRed:0.27f green:0.67f blue:0.38f alpha:1.0f];
    UIColor *secondColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    NSArray *colors = [NSArray arrayWithObjects:firstColor, secondColor, nil];
    
    [[CRGradientNavigationBar appearance] setBarTintGradientColors:colors];

    // Nos establecemos como delegados del SplitViewController
    self.splitViewController.delegate = self;
    
    // Nos establecemos como delegados del SearchBar
    self.searchBar.delegate = self;
    self.activeSearch = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([self.searchBar.text isEqualToString:@""]){
        self.activeSearch = false;
    } else {
        self.activeSearch = true;
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.activeSearch){
        return [self.searchArray count];
    } else {
        return [self.seriesArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"standarCell" forIndexPath:indexPath];
    // Configure the cell...
    
    standarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"standarCell" forIndexPath:indexPath];

    SerieModel *xModel = nil;
    
    if (self.activeSearch) {
        xModel = self.searchArray[indexPath.row];

    } else {
        xModel = self.seriesArray[indexPath.row];
    }

    cell.serieImageView.image = [UIImage imageNamed:@"load-image.png"];
    
    //cell.serieImageView.image = xModel.cover;
    cell.serieLabel.text = xModel.title;
    
    [cell showImageFromURL:xModel.coverURL];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Si estamos en modo "busqueda" tenemos que mostrar la información equivalente del array original de datos
    if(self.activeSearch){
        NSString *searchTitleSelected = [[self.searchArray objectAtIndex:indexPath.row] title];
        
        NSLog(@"estamos en busqueda: seleleccionamos %@", searchTitleSelected);
        
        for (int i = 0; i< self.seriesArray.count; i++ ){
            if ([[self.seriesArray[i] title] isEqualToString:searchTitleSelected]){
                self.aModel = [self.seriesArray objectAtIndex:i];
                    NSLog(@"NUM POS tabla: %d", (int)indexPath.row);
                    NSLog(@"NUM POS array: %d", i);
            }
        }
    } else {
        self.actualRow = (int)indexPath.row;
        self.aModel = [self.seriesArray objectAtIndex:indexPath.row];
    }
    
    NSLog(@"id de la serie seleccionada: %d", self.aModel.idSerie);

    if (self.aModel.infoDesc == nil) {
        // es un elemento que no tenemos cargado en memoria, actualizamos su contenido
        [self getModelDataFromURL:self.aModel.idSerie];
    } else {
        [self performSegueWithIdentifier:@"showDetail" sender:self.aModel];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - UISplitViewControllerDelegate

-(bool)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController{
    
    return true;
}

-(BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(id)sender
{
    UINavigationController *navController = (UINavigationController*)vc;
    UIViewController *rootViewController = navController.topViewController;
    
    rootViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    rootViewController.navigationItem.leftItemsSupplementBackButton = true;
    
    if (![self.searchBar.text isEqualToString:@""]){
        NSLog(@"volvemos y tengo: %d", (int)self.searchArray.count);
    }
    
    return false;
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        
        SerieDetailViewController *destination = (SerieDetailViewController *) [[segue destinationViewController] topViewController];
        
        SerieModel *selectedSerieModel = sender;
        
        destination.aModel = selectedSerieModel;
        NSLog(@"LOG: Ya lo cogi");
        
        destination.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        self.navigationItem.leftItemsSupplementBackButton = true;
    }
}




#pragma mark - JSON


-(void)getMasterTableDataFromURL:(int) pageNum {
    
    // API key: 7d34f86cc14ecd73a16b9d1838c88a13
    // Example: https://api.themoviedb.org/3/movie/550?api_key=7d34f86cc14ecd73a16b9d1838c88a13
    
    NSString *baseUrl = @"https://api.themoviedb.org/3/tv/";
    NSString *sectionUrl = @"popular";
    NSString *apiKeyUrl = @"?api_key=7d34f86cc14ecd73a16b9d1838c88a13";
    NSString *extrasUrl = @"&language=en-US=pages&page=";

    NSString *finalUrl = [NSString stringWithFormat:@"%@%@%@%@%d", baseUrl, sectionUrl, apiKeyUrl, extrasUrl, pageNum];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:finalUrl]];
    
    NSURLSessionDataTask *task = [[self getURLSession] dataTaskWithRequest:request
                                                         completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        dispatch_async( dispatch_get_main_queue(),
                       ^{
                           if (data != nil) {
                               // No ha habido error
                               NSError *jsonError;
                               NSDictionary *parsedJSONArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                               
                               if (parsedJSONArray != nil) {
                                   // No ha habido error
                                   
                                   // Carga total de la tabla

                                       NSArray *itemsArray = [parsedJSONArray objectForKey:@"results"];
                                       
                                       for (NSDictionary *dict in itemsArray){

                                           if (([dict objectForKey:@"poster_path"] != (id)[NSNull null]) &&
                                               ([dict objectForKey:@"overview"] != (id)[NSNull null])    &&
                                               (![[dict objectForKey:@"overview"] isEqualToString:@""]))
                                           {
                                               self.aModel = [[SerieModel alloc] initMasterWithDictionary:dict];
                                               [self.seriesArray addObject:self.aModel];
                                           }
                                           else {
                                               NSLog(@"Serie descartada: %@", [dict objectForKey:@"name"]);
                                           }
                                       }
                                       
                                       [self.tableView reloadData];
                                       
                                       // actualizamos el contenido del primer item
                                       self.aModel = [self.seriesArray objectAtIndex:self.actualRow];
                                       
                                       // inicializamos la pantalla de detalle con la primera serie de la lista
                                       // solo si estamos en ipad
                                       
                                       if (!(IS_IPHONE) && pageNum == 1) {
                                           [self selectFirstRow];
                                           [self getModelDataFromURL:self.aModel.idSerie];
                                       }
                               } else {
                                   NSLog(@"Error al parsear JSON: %@", jsonError.localizedDescription);
                               }
                           } else {
                               NSLog(@"Error al descargar datos del servidor: %@", error.localizedDescription);
                           }
                       });
    }];
    [task resume];
}

-(void)getModelDataFromURL:(int) idForUpdateItem {
    
    // API key: 7d34f86cc14ecd73a16b9d1838c88a13
    // Example: https://api.themoviedb.org/3/movie/550?api_key=7d34f86cc14ecd73a16b9d1838c88a13
    
    NSString *baseUrl = @"https://api.themoviedb.org/3/tv/";
    NSString *sectionUrl = nil;
    NSString *apiKeyUrl = @"?api_key=7d34f86cc14ecd73a16b9d1838c88a13";
    NSString *extrasUrl = @"&language=en-US";
    
    if (idForUpdateItem < 0){
        sectionUrl = @"popular";
    } else {
        sectionUrl = [NSString stringWithFormat:@"%d",idForUpdateItem];
    }
    
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@%@%@", baseUrl, sectionUrl, apiKeyUrl, extrasUrl];
    
    NSLog(@"%@", finalUrl);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:finalUrl]];
    
    NSURLSessionDataTask *task = [[self getURLSession] dataTaskWithRequest:request
                                                         completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      dispatch_async( dispatch_get_main_queue(),
                                                     ^{
                                                         if (data != nil) {
                                                             // No ha habido error
                                                             NSError *jsonError;
                                                             NSDictionary *parsedJSONArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                                                             
                                                             if (parsedJSONArray != nil) {
                                                                 // No ha habido error
                                                                 
                                                                 // Actualizacion de un item concreto en la vista de detalle
                                                                 
                                                                 [self.aModel updateModelWithDictionary:parsedJSONArray];
                                                                 
                                                                 NSLog (@"aqui vamos: %@", self.aModel.backdropURL);
                                                                 
                                                                 [self performSegueWithIdentifier:@"showDetail" sender:self.aModel];
                                                                 
                                                             } else {
                                                                 NSLog(@"Error al parsear JSON: %@", jsonError.localizedDescription);
                                                             }
                                                             
                                                         } else {
                                                             NSLog(@"Error al descargar datos del servidor: %@", error.localizedDescription);
                                                         }
                                                     });
                                  }];
    [task resume];
}



-(NSURLSession * )getURLSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,
                  ^{
                      NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                      session = [NSURLSession sessionWithConfiguration:configuration];
                  });
    
    return session;
}


// Damos efecto de selección a la primera fila de la tabla si estamos en modo ipad

-(void)selectFirstRow {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    // optional:
    // [self tableView:myTable willSelectRowAtIndexPath:indexPath];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    // optional:
    // [self tableView:myTable didSelectRowAtIndexPath:indexPath];
}


#pragma mark - UISearchBarDelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.activeSearch = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.activeSearch = NO;
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search button clic");
    self.activeSearch = NO;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    self.searchArray = nil;
    self.searchArray = [NSMutableArray array];
    
    if ([searchText isEqualToString:@""]){
        self.activeSearch = NO;

    } else {
        self.activeSearch = YES;
    }

    NSLog(@"activeSearch: %@", self.activeSearch ? @"YES" : @"NO");
    
    if (self.activeSearch) {
        for (int i = 0; i< self.seriesArray.count; i++) {
            if ([[self.seriesArray[i] title] rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [self.searchArray addObject:self.seriesArray[i]];
            }
        }
    }
    
    [self.tableView reloadData];
}

-(void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
        NSLog(@"bookmark button clic");
}

@end
