//
//  HomeViewController.h
//  PopularMoviesProject
//
//  Created by Ahmed Aboelnaga on 9/10/18.
//  Copyright © 2018 Ahmed Aboelnaga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <JSONModel.h>
#import "Netwok.h"
#import "AFHTTPSessionManager.h"
#import "DetailViewController.h"
#import "PFNavigationDropdownMenu.h"

@interface HomeViewController : UICollectionViewController <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIPickerView *sortPicker;
-(void)fetchTopRated;
-(void)fetchMostPopular;
@end
