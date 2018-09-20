//
//  DetailViewController.m
//  PopularMoviesProject
//
//  Created by Ahmed Aboelnaga on 9/11/18.
//  Copyright © 2018 Ahmed Aboelnaga. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController (){
    
    Netwok *net;
    int flag;
    NSString *docsDir;
    NSArray *dirPaths;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ids = [NSMutableString new];
    _idS = [NSMutableArray new];
    
    [_movieName setText:_name];
    [_movieTitle setText:_t];
    [_overView setText:_o];
    [_avg_rate setText:_rate];
    [_releaseDate setText:_r];
    [_movieImage sd_setImageWithURL:[NSURL URLWithString:_pic] placeholderImage:[UIImage imageNamed:@"Loading_icon.gif"]];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"contacts.db"]];
    
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt =
        "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, PICS TEXT, IDs TEXT, overview text , avgrate double , releasedate text, flag intger)";
        
        if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to create table");
        }
        sqlite3_close(_contactDB);
    } else {
        printf("Failed to open/create database");
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)trailarButton:(UIButton *)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@/videos?api_key=8004441caa19638a8eb3ee9876b60817",_movieId];
    
    NSURL *url = [NSURL URLWithString:urlString];

    AFHTTPSessionManager *manager   = [AFHTTPSessionManager manager];
    
    [manager    GET:url.absoluteString
         parameters:nil
           progress:nil
            success:^(NSURLSessionTask *task, id responseObject) {
                NSDictionary *fullResponse = (NSDictionary *)responseObject;
                NSArray *trailersList = fullResponse[@"results"];
                NSString *key = trailersList[0][@"key"];
                NSString *youtubeLink = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",key];
                //NSLog(@"%@",youtubeLink);
                NSURL *youtubeUrl = [NSURL URLWithString:youtubeLink];
                if ([[UIApplication sharedApplication] canOpenURL:youtubeUrl]) {
                    [[UIApplication sharedApplication] openURL:youtubeUrl];
                }
            }
            failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"%@",error);
            }
     ];
}

- (IBAction)favAction:(UIButton*)sender {
    
    //[sender setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"contacts.db"]];
    
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  * FROM contacts where ids = \"%@\" ",_movieId];
        
        //printf("here");
        
        const char *query_stmt = [querySQL UTF8String];
        //NSLog(@"%s",query_stmt);
        if (sqlite3_prepare_v2(_contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //printf("here2");
            while(sqlite3_step(statement) == SQLITE_ROW){
                
                _ids = [[NSMutableString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                [_idS addObject:_ids];
                
                printf("Match found\n");
                flag = 1;
            }
            sqlite3_finalize(statement);
        }else{
            printf("Match not found\n");
            flag = 0;
        }
        sqlite3_close(_contactDB);
    }
    
    
    
    if(flag == 0){
        sqlite3_stmt    *statement;
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO CONTACTS (name, pics, ids , overview , avgrate, releasedate ) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",
                                   _movieName.text, _pic , _movieId, _o, _rate ,_r];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_contactDB, insert_stmt,
                               -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                //[sender setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
                printf("movie is added\n");
            } else {
                //[sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                printf("movie is not added\n");
            }
            sqlite3_finalize(statement);
            sqlite3_close(_contactDB);
            flag = 1;
            [sender setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        }
    }else{
        
        
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        docsDir = dirPaths[0];
        _databasePath = [[NSString alloc]
                         initWithString: [docsDir stringByAppendingPathComponent:
                                          @"contacts.db"]];
        
        sqlite3_stmt    *statement;
        
        const char *dbpath = [_databasePath UTF8String];
        
        
        int rc;
        
        rc = sqlite3_open( dbpath, &_contactDB );
        
        if ( rc )
        {
            sqlite3_close(_contactDB);
        }
        else //Database connection opened successfuly
        {
            //char *zErrMsg = 0;
            
            // rc = sqlite3_exec( _contactDB, "DELETE name, pics, ids , overview , avgrate, releasedate FROM contacts where ids = \"%@\"", _movieId , NULL ,NULL ,zErrMsg);
            
            NSString *delete =  [NSString stringWithFormat:
                                 @"Delete from CONTACTS where ids=\"%@\"",
                                 _movieId];
            const char *del = [delete UTF8String];
            sqlite3_prepare_v2(_contactDB, del,
                               -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                printf("movie is deleted\n");
            }else {
                printf("movie is not deleted\n");
            }
            sqlite3_finalize(statement);
            sqlite3_close(_contactDB);
            flag = 0;
            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        
    }

}
@end
