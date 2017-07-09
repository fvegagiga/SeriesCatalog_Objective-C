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

@end


@implementation MasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.seriesArray = [NSMutableArray array];
    
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAutomatic;
    
    UINavigationController *navController = self.splitViewController.viewControllers[1];
    SerieDetailViewController *rootDetailViewController = (SerieDetailViewController*)navController.topViewController;
    rootDetailViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = true;
    
    // inicializamos el modelo de datos
    [self initializeModel];
    //[self getModelDataFromURL];

    rootDetailViewController.aModel = [self.seriesArray objectAtIndex:0];
    
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
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        SerieDetailViewController *destination = (SerieDetailViewController *) [[segue destinationViewController] topViewController];
        destination.aModel = [self.seriesArray objectAtIndex:indexPath.row];
        
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
    
    cell.imageView.image = xModel.cover;
    cell.serieLabel.text = xModel.title;
    
    return cell;
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



#pragma mark - Model data

-(void) initializeModel{
    
    self.aModel = [SerieModel serieWithTitle:@"The Walking Dead"
                                  serieGenre:@[ @"Terror", @"Drama" ]
                                   serieInfo:@"Tras despertar de un coma en un hospital abandonado, el oficial de policía Rick Grimes (Andrew Lincoln) se da cuenta de que el mundo que conocía ya no existe y de que el caos se ha apoderado de la ciudad debido a que inexplicablemente los muertos caminantes dominan las calles. A las afueras de Atlanta, un pequeño campamento lucha por sobrevivir mientras los muertos-vivientes los acechan a cada momento.16 Dicho grupo, guiado por Shane Walsh (Jon Bernthal), pasa a ser liderado por Rick, a quien encuentran después de haberlo dado por muerto. Este último anteriormente había encontrado en Atlanta a un grupo pequeño que ha ido a la ciudad a buscar víveres. Mientras su situación se vuelve más y más sombría, la desesperación del grupo por sobrevivir les obliga a hacer cosas que en su vida anterior a la plaga caminantes no se habrían imaginado hacer jamás.17"
                                serieSeasons:7
                                  serieCover:[UIImage imageNamed:@"the-walking-dead-cover.jpg"]
                                serieInfoWeb:[NSURL URLWithString:@"http://www.amc.com/shows/the-walking-dead"]];
    
    
    [self.seriesArray addObject:self.aModel];
    
    self.aModel = [SerieModel serieWithTitle:@"Prison Break"
                                  serieGenre:@[ @"Accion" ]
                                   serieInfo:@"Prison Break, también conocida como Prison Break: En busca de la verdad en Hispanoamérica, es una serie de televisión dramática estadounidense."
                                serieSeasons:5
                                  serieCover:[UIImage imageNamed:@"prisonBreak.jpg"]
                                serieInfoWeb:[NSURL URLWithString:@"http://www.foxtv.es/series/fox/prison-break"]];
    
    
    [self.seriesArray addObject:self.aModel];
}

-(void)getModelDataFromURL {
    
    // API key: 7d34f86cc14ecd73a16b9d1838c88a13
    // Example: https://api.themoviedb.org/3/movie/550?api_key=7d34f86cc14ecd73a16b9d1838c88a13

    NSString *baseUrl = @"https://api.themoviedb.org/3/movie/550?api_key=7d34f86cc14ecd73a16b9d1838c88a13";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:baseUrl]];
    
    
    
    NSURLSessionDataTask *task = [[self getURLSession] dataTaskWithRequest:request
                                                         completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        dispatch_async( dispatch_get_main_queue(),
                       ^{
                           NSError *jsonError;
                           NSArray *parsedJSONArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];

                           NSLog(@"%@", parsedJSONArray[0]);
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
