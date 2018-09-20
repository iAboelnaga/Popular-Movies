//
//  HomeViewController.m
//  PopularMoviesProject
//
//  Created by Ahmed Aboelnaga on 9/10/18.
//  Copyright © 2018 Ahmed Aboelnaga. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController (){
    
    NSString *imagesUrl;
    NSArray *images;
    Netwok *net;
}

@property(nonatomic, strong) UIView *titleView;

@end

@implementation HomeViewController
static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchMostPopular];
    
    NSArray *items = @[@"Most Popular", @"Highest Rated"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:180/255.0 blue:220/255.0 alpha:1.0];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [UINavigationBar appearance].barStyle = UIBarStyleDefault;
    
    PFNavigationDropdownMenu *menuView = [[PFNavigationDropdownMenu alloc] initWithFrame:CGRectMake(0, 0, 300, 44)
                                                                    title:items[0]                                                            items:items
                                                                           containerView:self.view];
    
    menuView.cellHeight = 50;
    menuView.cellBackgroundColor = self.navigationController.navigationBar.barTintColor;
    //menuView.arrowImage = [UIImage imageNamed:@"arrow_down_icon@2x.png"] ;
    menuView.cellSelectionColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:195/255.0 alpha: 1.0];
    menuView.cellTextLabelColor = [UIColor whiteColor];
    menuView.cellTextLabelFont = [UIFont fontWithName:@"Avenir-Heavy" size:17];
    menuView.arrowPadding = 10;
    menuView.animationDuration = 0.5f;
    menuView.maskBackgroundColor = [UIColor blackColor];
    menuView.maskBackgroundOpacity = 0.3f;
    menuView.didSelectItemAtIndexHandler = ^(NSUInteger indexPath){
        
        
        if (indexPath == 0) {
            [self fetchMostPopular];
        }else{
            [self fetchTopRated];
        }
    
    
    };
    self.navigationItem.titleView = menuView;
}
-(void)fetchMostPopular{
    net = [Netwok new];
    NSString *urlString = @"http://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=8004441caa19638a8eb3ee9876b60817";
    //NSURL *url = [NSURL URLWithString:urlString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET: urlString
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             //NSLog(@"JSON: %@", responseObject);
             net.title = [responseObject valueForKeyPath:@"results.original_title"];
             net.overview = [responseObject valueForKeyPath:@"results.overview"];
             net.release_date = [responseObject valueForKeyPath:@"results.release_date"];
             net.vote_average = [responseObject valueForKeyPath:@"results.vote_average"];
             net.poster_path = [responseObject valueForKeyPath:@"results.poster_path"];
             net.ids = [responseObject valueForKeyPath:@"results.id"];
             
             //NSLog(@"JSON: %@", net.ids );
             
             
             [self.collectionView reloadData];
             
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             // Handle failure
         }];
}

-(void)fetchTopRated{
    
    net = [Netwok new];
    NSString *urlString = @"http://api.themoviedb.org/3/discover/movie?certification_country=US&certification=R&sort_by=vote_average.desc&api_key=8004441caa19638a8eb3ee9876b60817";
    //NSURL *url = [NSURL URLWithString:urlString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET: urlString
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             //NSLog(@"JSON: %@", responseObject);
             net.title = [responseObject valueForKeyPath:@"results.original_title"];
             net.overview = [responseObject valueForKeyPath:@"results.overview"];
             net.release_date = [responseObject valueForKeyPath:@"results.release_date"];
             net.vote_average = [responseObject valueForKeyPath:@"results.vote_average"];
             net.poster_path = [responseObject valueForKeyPath:@"results.poster_path"];
             net.ids = [responseObject valueForKeyPath:@"results.id"];
             
             //NSLog(@"JSON: %@", net.ids );
             
             
             [self.collectionView reloadData];
             
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             // Handle failure
         }];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [net.poster_path count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    UIImageView *cellImageView = [cell viewWithTag:2];
    imagesUrl = [NSString new];
    imagesUrl = [@"https://image.tmdb.org/t/p/w185/" stringByAppendingString:[net.poster_path objectAtIndex:indexPath.row]];
    
    [cellImageView sd_setImageWithURL:[NSURL URLWithString: imagesUrl] placeholderImage:[UIImage imageNamed:@"Loading_icon.gif"]];
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth = [[UIScreen mainScreen] bounds].size.width/2;
    CGFloat cellHeight = cellWidth * 1.5;
    return CGSizeMake(cellWidth, cellHeight);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    NSString *s1 = [net.title objectAtIndex:indexPath.row];
    NSString *s2 = [net.release_date objectAtIndex:indexPath.row];
    NSString *s3 = [net.overview objectAtIndex:indexPath.row];
    NSString *s4 = [NSString stringWithFormat:@"%@", [net.vote_average objectAtIndex:indexPath.row]];
    NSString *s5 = [@"http://image.tmdb.org/t/p/w185/" stringByAppendingString: [net.poster_path objectAtIndex:indexPath.row]];
    NSString *s6 = [net.ids objectAtIndex:indexPath.row] ;
    
    //NSLog(@"Value of title %@",[[result objectAtIndex:indexPath.row] objectForKey:@"vote_average"]);
    [details setName:s1];
    [details setR:s2];
    [details setO:s3];
    [details setRate:s4];
    [details setPic:s5];
    [details setMovieId:s6];
    [details setT:s1];
    
    //NSLog(@"movie id%@", s6);
    
    [self.navigationController pushViewController:details animated:YES];
    
    
}
@end
