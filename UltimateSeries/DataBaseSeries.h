//
//  DataBaseSeries.h
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 21/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface DataBaseSeries : NSObject

// Para poder gestionar desde fuera la BBDD, creamos esta propiedad pública
@property (nonatomic, strong) NSManagedObjectContext *moc;

+(DataBaseSeries *)defaultDataBase;
-(void)save;

@end
