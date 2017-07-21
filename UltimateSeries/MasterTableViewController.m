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
#import <HTMLReader.h>

#define IS_IPHONE UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone

@interface MasterTableViewController ()

@property (strong, nonatomic) SerieModel *aModel;
@property (assign, nonatomic) int actualRow;
@property (assign, nonatomic) int totalPages;

@property (nonatomic) BOOL activeSearch;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (copy, nonatomic) NSString *apiKey;
@property (nonatomic) BOOL firstTimeObject;

- (IBAction)actionButtonPressed:(id)sender;

@end


@implementation MasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.seriesArray = [NSMutableArray array];
    self.searchArray = [NSMutableArray array];
    
    self.actualRow = 0;
    self.firstTimeObject = YES;
    
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAutomatic;
    
    // inicializamos el modelo de datos:
    //          - tabla de la escena Master;
    //          - escena Detail con la información del primer registro
    
    self.apiKey = [self getApiKeyFromURL];
    
    self.totalPages = 25;
    for (int i = 1; i <= self.totalPages; i++){
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
    
    // Libreria CRGradientNavigationBar para el gradiente en la barra de navegación
    [[CRGradientNavigationBar appearance] setBarTintGradientColors:colors];

    // Nos establecemos como delegados del SplitViewController
    self.splitViewController.delegate = self;
    
    // Nos establecemos como delegados del SearchBar
    self.searchBar.delegate = self;
    self.activeSearch = NO;
    
    
    // Establecemos las propiedades de la toolbar
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
    UIColor *toolBarColor = [UIColor colorWithRed:0.07f green:0.18f blue:0.11f alpha:1.0f];

    self.navigationController.toolbar.barTintColor = toolBarColor;

    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([self.searchBar.text isEqualToString:@""]){
        self.activeSearch = false;
    } else {
        self.activeSearch = true;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
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

    cell.serieLabel.text = xModel.title;
    cell.serieImageView.image = [UIImage imageNamed:@"load-image.png"];
    
    [cell showImageFromURL:xModel.coverURL];
    
    // configuramos los iconos de los botones
    // uso de la librería FontAwesomeKit para los iconos
    // y la librería MGSwipeTableCell para los menus en las celdas
    
    NSError *error;
    FAKFontAwesome *heartIcon = [FAKFontAwesome  iconWithIdentifier:@"fa-heart" size:25 error:&error];
    
    UIColor *buttonColor = (id)[UIColor colorWithRed:0.35f green:0.75f blue:0.42f alpha:1.0f];
    
    [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]];
    UIImage *iconImageFav = [heartIcon imageWithSize:CGSizeMake(50, 50)];
    
    // configuramos los botones de la izquierda
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"" icon:iconImageFav backgroundColor:nil]];
    cell.leftSwipeSettings.transition = MGSwipeTransition3D;
    
    cell.layer.cornerRadius = 30;
    cell.clipsToBounds = true;
    cell.swipeBackgroundColor = buttonColor;
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:0.11 green:0.26 blue:0.15 alpha:1];
    [cell setSelectedBackgroundView:myBackView];
    
    // delegado MGSwipeTableCell
    cell.delegate = self;
    
    return cell;
}

-(void)extractCellInfo: (NSIndexPath*) indexPath {
    
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
    
    // al seleccionar una fila de la tabla, quitamos el foco del campo de busqueda
    [self.searchBar resignFirstResponder];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self extractCellInfo:indexPath];
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
#pragma mark - MGSwipeTableCellDelegate

-(void)swipeTableCell:(MGSwipeTableCell *)cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive{
    gestureIsActive ? NSLog(@"si esta activa"): NSLog(@"no esta activa");
}

-(void)swipeTableCellWillBeginSwiping:(MGSwipeTableCell *)cell{
    self.activeSearch? NSLog(@"ATENCION!: estamos en modo search") : NSLog(@"ATENCION!: no estamos en modo search");
    
    // eliminamos el foco del campo de búsqueda cuando desplazamos una celda
    [self.searchBar resignFirstResponder];
    
    if ([self.searchBar.text isEqualToString:@""]){
        self.activeSearch = NO;
    }
    else {
        self.activeSearch = YES;
    }

}

-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    
    // seleccionamos la celda que se acaba de marcar como favorita para que los datos concuerden (master / detail)
    [self.tableView selectRowAtIndexPath:indexpath animated:true scrollPosition:false];
    [self extractCellInfo:indexpath];
    
    return YES;
}


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
        
        destination.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        self.navigationItem.leftItemsSupplementBackButton = true;
    }
}




#pragma mark - Server

-(NSString *)getApiKeyFromURL {
    
//    LLamada sincrona para recibir el api-key
//    original: https://notepad.pw/fvg0902_intent
    
//    NSURL *apiURL = [NSURL URLWithString: @"https://notepad.pw/markdown/f4kshl83l"];
//    NSData *apiData = [NSData dataWithContentsOfURL:apiURL];
//    
//    NSString *apiWebStr = [[NSString alloc] initWithData:apiData encoding:NSUTF8StringEncoding];
//    
//    HTMLDocument *document = [HTMLDocument documentWithString:apiWebStr];
//    
//    //NSString *apiKeyString = [[document firstNodeMatchingSelector:@"p"] textContent];
//    NSArray *apiKeyElement = [document nodesMatchingParsedSelector:@"div"];
//    NSString *apiKeyString = [[apiKeyElement[2] firstNodeMatchingSelector:@"p"] textContent];

    NSString *apikeyStr = @"7d34f86cc14ecd73a16b9d1838c88a13";
    return apikeyStr;
}

-(NSString *)getUrlAddress:(int) idForUpdateItem {
    
    NSString *baseUrl = @"https://api.themoviedb.org/3/tv/";
    NSString *sectionUrl = nil;
    NSString *apiKeyUrl = @"?api_key=";
    NSString *extrasUrl = nil;
    
    if (idForUpdateItem < 0) {
        sectionUrl = @"popular";
        extrasUrl = @"&language=en-US&page=";
    }
    else {
        sectionUrl = [NSString stringWithFormat:@"%d",idForUpdateItem];
        extrasUrl = @"&language=en-US";
    }
    
    return [NSString stringWithFormat:@"%@%@%@%@%@", baseUrl, sectionUrl, apiKeyUrl, self.apiKey, extrasUrl];
}

-(void)getMasterTableDataFromURL:(int) pageNum {
    
    NSString *pageNumString = [NSString stringWithFormat:@"%d", pageNum];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[[self getUrlAddress:-1] stringByAppendingString:pageNumString]]];
    
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
                                       
                                       // motivos de descarte de una serie (no tener informados ciertos campos)
                                       if (([dict objectForKey:@"poster_path"] != (id)[NSNull null]) &&
                                           ([dict objectForKey:@"overview"] != (id)[NSNull null])    &&
                                           (![[dict objectForKey:@"overview"] isEqualToString:@""])  &&
                                           ([dict objectForKey:@"backdrop_path"] != (id)[NSNull null]))
                                       {
                                           self.aModel = [[SerieModel alloc] initMasterWithDictionary:dict];
                                           [self.seriesArray addObject:self.aModel];
                                           
                                           //NSLog(@"Serie insertada: %@ - pagina %d", [dict objectForKey:@"name"], pageNum);
                                       } else {
                                           //NSLog(@"Serie descartada: %@", [dict objectForKey:@"name"]);
                                       }
                                   }
                                   
                                   [self.tableView reloadData];
                                   
                                   // actualizamos el contenido del detalle con el primer item de la lista
                                   // solo si estamos en modo ipad
                                   
                                   if (!(IS_IPHONE) &&
                                         pageNum == self.totalPages &&
                                         self.firstTimeObject == YES) {

                                       self.aModel = [self.seriesArray objectAtIndex:self.actualRow];
                                       //[self selectFirstRow];
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
    
    NSLog (@"Recuperamos informacion completa de: %d", self.aModel.idSerie);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[self getUrlAddress:idForUpdateItem]]];
    
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
                                                                 
                                                                 NSLog(@"media votos: %d", self.aModel.votesAverage);
                                                                 
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


-(void)selectFirstRow {
    // Damos efecto de selección a la primera fila de la tabla si estamos en modo ipad
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}


#pragma mark - UISearchBarDelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    // inicializamos el array que contiene los resultados de búsqueda
    self.searchArray = nil;
    self.searchArray = self.seriesArray;
    
    self.activeSearch = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

    [searchBar resignFirstResponder];
    
    if ([searchBar.text isEqualToString:@""]){
        self.activeSearch = NO;
        NSLog(@"desactivado search mode");
    }
    else {
        self.activeSearch = YES;
        NSLog(@"mantenemos activo search mode");
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search button clic");
    [searchBar resignFirstResponder];
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

- (IBAction)actionButtonPressed:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ordenar lista"
                                                                   message:@"¿Desea ordenar la lista?"
                                                            preferredStyle: UIAlertControllerStyleAlert];
    
    NSSortDescriptor *sortTitleAsc = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSSortDescriptor *sortTitleDesc = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];

    
    UIAlertAction *sortAscButton = [UIAlertAction actionWithTitle:@"Ascendente"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          NSArray *auxArray = [NSArray array];
                                                          
                                                          // con el modo de búsqueda activo ordenamos el array correspondiente
                                                          if (self.activeSearch) {
                                                              auxArray = [self.searchArray sortedArrayUsingDescriptors:@[sortTitleAsc]];
                                                              self.searchArray = nil;
                                                              self.searchArray = [auxArray copy];
                                                              NSLog(@"search ordenado - %lu", (unsigned long)self.searchArray.count);
                                                          }
                                                          
                                                          else {
                                                              auxArray = [self.seriesArray sortedArrayUsingDescriptors:@[sortTitleAsc]];
                                                              self.seriesArray = nil;
                                                              self.seriesArray = [auxArray copy];
                                                              NSLog(@"normal ordenado");

                                                          }
                                                          [self.tableView reloadData];
                                                          // Nos posicionamos en la parte superior
                                                          self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
                                                          
                                                      }];
    
    UIAlertAction *sortDescButton = [UIAlertAction actionWithTitle:@"Descendente"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          NSArray *auxArray = [NSArray array];

                                                          // con el modo de búsqueda activo ordenamos el array correspondiente
                                                          if (self.activeSearch) {
                                                              auxArray = [self.searchArray sortedArrayUsingDescriptors:@[sortTitleDesc]];
                                                              self.searchArray = nil;
                                                              self.searchArray = [auxArray copy];
                                                          }
                                                          
                                                          else {
                                                              NSArray *auxArray = [self.seriesArray sortedArrayUsingDescriptors:@[sortTitleDesc]];
                                                              
                                                              self.seriesArray = nil;
                                                              self.seriesArray = [auxArray copy];
                                                          }
                                                          
                                                          [self.tableView reloadData];
                                                          self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
                                                      }];
    
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No, thanks"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil ];
    
    [alert addAction:sortAscButton];
    [alert addAction:sortDescButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
