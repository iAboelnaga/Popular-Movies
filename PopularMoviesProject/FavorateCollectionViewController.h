//
//  FavorateCollectionViewController.h
//  PopularMoviesProject
//
//  Created by Ahmed Aboelnaga on 9/14/18.
//  Copyright © 2018 Ahmed Aboelnaga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Netwok.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailViewController.h"
#import "AFHTTPSessionManager.h"

@interface FavorateCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSString *databasePath;
@property ( nonatomic) sqlite3 *contactDB ;
@property NSMutableArray *original_title;
@property NSMutableArray *overview;
@property NSMutableArray *vote_average;
@property NSMutableArray *release_date;
@property NSMutableArray *poster_path;
@property NSMutableArray *ids;

@end
