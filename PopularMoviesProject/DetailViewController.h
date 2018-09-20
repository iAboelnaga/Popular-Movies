//
//  DetailViewController.h
//  PopularMoviesProject
//
//  Created by Ahmed Aboelnaga on 9/11/18.
//  Copyright © 2018 Ahmed Aboelnaga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Netwok.h"
#import <sqlite3.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>

@interface DetailViewController : UIViewController<NSFileManagerDelegate>


@property (strong, nonatomic) NSString *databasePath;
@property ( nonatomic) sqlite3 *contactDB ;

@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *releaseDate;
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UILabel *avg_rate;
@property (weak, nonatomic) IBOutlet UITextView *overView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;

- (IBAction)trailarButton:(UIButton *)sender;

- (IBAction)favAction:(UIButton*)sender;

@property NSString *name;
@property NSString *l;
@property NSString *t;
@property NSString *r;
@property NSString *o;
@property NSString *rate;
@property NSString *pic;
@property NSString *movieId;
@property NSString *movieLinkWithId;
@property NSString *mykey;
@property NSMutableArray *movieIdForPlist;
@property NSMutableArray *idS;
@property NSMutableString *ids;

@end
