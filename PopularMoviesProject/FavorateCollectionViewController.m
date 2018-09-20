//
//  FavorateCollectionViewController.m
//  PopularMoviesProject
//
//  Created by Ahmed Aboelnaga on 9/14/18.
//  Copyright © 2018 Ahmed Aboelnaga. All rights reserved.
//

#import "FavorateCollectionViewController.h"

@interface FavorateCollectionViewController (){
    NSString *pic;
    NSString *name;
    NSString *idS;
    NSString *overView;
    NSString *avg;
    NSString 
    *release;
    
}

@end

@implementation FavorateCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:180/255.0 blue:220/255.0 alpha:1.0];    
    self.title = @"Favourites";
    
    printf(".......!!");
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    _poster_path = [NSMutableArray new];
    _original_title = [NSMutableArray new];
    _ids = [NSMutableArray new];
    _overview = [NSMutableArray new];
    _vote_average = [NSMutableArray new];
    _release_date = [NSMutableArray new];
    
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"contacts.db"]];
    
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        // NSString *ids = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
        //NSLog(@"%@",ids);
        NSString *querySQL = [NSString stringWithFormat:@"SELECT pics , ids , name ,overview , avgrate, releasedate FROM contacts"];
        
        //printf("here");
        
        const char *query_stmt = [querySQL UTF8String];
        //NSLog(@"%s",query_stmt);
        if (sqlite3_prepare_v2(_contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //printf("here2");
            while(sqlite3_step(statement) == SQLITE_ROW){
                
                pic = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                [_poster_path addObject:pic];
                //NSLog(@"%@", _poster_path );
                
                idS = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                [_ids addObject:idS];
                
                name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                [_original_title addObject:name];
                
                overView = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement,3)];
                [_overview addObject:overView];
                
                avg = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                [_vote_average addObject:avg];
                
                release = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                [_release_date addObject:release];
                
                
                printf("Match found");
            }
            sqlite3_finalize(statement);
        }else{
            printf("Match not found");
        }
        sqlite3_close(_contactDB);
    }
    
    
    [self.collectionView reloadData];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_poster_path count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavouritesTab" forIndexPath:indexPath];
    UIImageView *imageView2 = [cell viewWithTag:67];
    [imageView2 sd_setImageWithURL:[NSURL URLWithString:[_poster_path objectAtIndex:indexPath.row]]placeholderImage:[UIImage imageNamed:@"Loading_icon.jpg"]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth = [[UIScreen mainScreen] bounds].size.width/2;
    CGFloat cellHeight = cellWidth * 1.5;
    return CGSizeMake(cellWidth, cellHeight);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    
    NSString *s1 = [_original_title objectAtIndex:indexPath.row];
    NSString *s2 = [_release_date objectAtIndex:indexPath.row];
    NSString *s3 = [_overview objectAtIndex:indexPath.row];
    NSString *rate = [NSString stringWithFormat:@"%@", [_vote_average objectAtIndex:indexPath.row]];
    NSString *s4;
    
    if([rate length]>=3){
        s4 = [rate substringToIndex:3];
    }else{
        s4 = rate;
    }
    NSMutableString *s5 = [_poster_path objectAtIndex:indexPath.row];
    NSString *s6 = [_ids objectAtIndex: indexPath.row];
    
    
    [details setName:s1];
    [details setR:s2];
    [details setO:s3];
    [details setRate:s4];
    [details setPic:s5];
    [details setMovieId:s6];
    
    
    [self.navigationController pushViewController:details animated:YES];
    
    
}
@end
