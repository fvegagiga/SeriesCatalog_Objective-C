//
//  MasterTableViewController.h
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 7/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerieModel.h"
#import <FontAwesomeKit.h>
#import <MGSwipeTableCell.h>

@interface MasterTableViewController : UITableViewController <UISplitViewControllerDelegate,
                                                                UISearchBarDelegate,
                                                                MGSwipeTableCellDelegate>

@property (nonatomic, strong) NSMutableArray *seriesArray;

@end
