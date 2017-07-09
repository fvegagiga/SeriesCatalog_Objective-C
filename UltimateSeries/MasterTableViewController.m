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

@interface MasterTableViewController ()

@property (strong, nonatomic) SerieModel *aModel;
@property (assign, nonatomic) int actualRow;


@end


@implementation MasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.seriesArray = [NSMutableArray array];
    
    self.actualRow = 0;
    
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAutomatic;
    
    // inicializamos el modelo de datos
    [self getModelDataFromURL:NO_INFO_NUM];

    
    UINavigationController *navController = self.splitViewController.viewControllers[1];
    SerieDetailViewController *rootDetailViewController = (SerieDetailViewController*)navController.topViewController;
    rootDetailViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = true;
    


    NSLog(@"LOG: continua la ejecución");
    //rootDetailViewController.aModel = [self.seriesArray objectAtIndex:0];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Segues

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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.seriesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"standarCell" forIndexPath:indexPath];
    // Configure the cell...
    
    standarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"standarCell" forIndexPath:indexPath];

    SerieModel *xModel = self.seriesArray[indexPath.row];

    cell.serieImageView.image = xModel.cover;
    cell.serieLabel.text = xModel.title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.actualRow = (int)indexPath.row;
    
    SerieModel *selectedSerieModel = [self.seriesArray objectAtIndex:indexPath.row];
    
    if (selectedSerieModel.infoDesc == nil) {
        // es un elemento que no tenemos cargado en memoria, actualizamos su contenido
        [self getModelDataFromURL:selectedSerieModel.idSerie];
    } else {
        [self performSegueWithIdentifier:@"showDetail" sender:selectedSerieModel];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - JSON


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
                                   SerieModel *serieActual = nil;
                                   // Carga total de la tabla
                                   if (idForUpdateItem < 0){
                                       NSArray *itemsArray = [parsedJSONArray objectForKey:@"results"];
                                       
                                       for (NSDictionary *dict in itemsArray){
                                           serieActual = [[SerieModel alloc] initMasterWithDictionary:dict];
                                           [self.seriesArray addObject:serieActual];
                                       }
                                       
                                       [self.tableView reloadData];
                                       
                                       // actualizamos el contenido del primer item
                                       serieActual = [self.seriesArray objectAtIndex:self.actualRow];
                                       [serieActual updateModelWithDictionary:parsedJSONArray];
                                       
                                       // inicializamos la pantalla de detalle con la primera serie de la lista
                                       [self getModelDataFromURL:serieActual.idSerie];
                                       
                                   } else {     // Actualizacion de un item concreto en la vista de detalle

                                       SerieModel *serieActual = [self.seriesArray objectAtIndex:self.actualRow];
                                       [serieActual updateModelWithDictionary:parsedJSONArray];
                                           NSLog(@"LOG: Termino la carga de datos");
                                       
                                       [self performSegueWithIdentifier:@"showDetail" sender:serieActual];

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


@end
