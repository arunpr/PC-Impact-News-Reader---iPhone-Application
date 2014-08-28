//
//  webservice.m
//  News
//
//  Created by Palani  on 12/23/13.
//  Copyright (c) 2013 Palani. All rights reserved.
//

#import "webservice.h"
#import "XMLReader.h"

@implementation webservice
{
    
    
}
@synthesize Dictionary;
-(void)Startconnection:(NSString *)urlString
{
    
NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.pcinpact.com/rss/news.xml"]];
 connetion1=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] ;
	webData = [NSMutableData data];
 
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
 //   [ShowAlert showMyAlert:@"Network Alert" :@"No Internet connection detected"];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
  
    NSString *thexml=[[NSString alloc] initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSASCIIStringEncoding];
    
    NSError *parseError = nil;
  Dictionary = [XMLReader dictionaryForXMLString:thexml error:&parseError];
    // Print the dictionary
  //  NSLog(@"%@",Dictionary);
    NSArray *myArray = [[[Dictionary objectForKey:@"rss"] objectForKey:@"channel"]  objectForKey:@"item"] ;
    
    NSLog(@"%@",myArray);
    

    

    NSString *imgUrl;
    NSString *description;
    NSString *pubdate;
    NSString *title;
    
    
    
//    NSString *trimmedText = [[[[[[[Dictionary objectForKey:@"rss"] objectForKey:@"channel"] objectForKey:@"item"] objectAtIndex:i] objectForKey:@"author"] objectForKey:@"text"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    for (int i=0; i<myArray.count; i++) {
        
    description=[[[[[[Dictionary objectForKey:@"rss"] objectForKey:@"channel"]  objectForKey:@"item"] objectAtIndex:i] objectForKey:@"description"] objectForKey:@"text"];
;
    
    pubdate=[[[[[[[Dictionary objectForKey:@"rss"] objectForKey:@"channel"] objectForKey:@"item"] objectAtIndex:i] objectForKey:@"pubDate"] objectForKey:@"text"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
;
    
    title=[[[[[[[Dictionary objectForKey:@"rss"] objectForKey:@"channel"]  objectForKey:@"item"] objectAtIndex:i] objectForKey:@"title"] objectForKey:@"text"] stringByTrimmingCharactersInSet:
               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
;
    imgUrl=[[[[[[Dictionary objectForKey:@"rss"] objectForKey:@"channel"]  objectForKey:@"item"] objectAtIndex:i] objectForKey:@"enclosure"] objectForKey:@"url"];
        if (!imgUrl.length>0) {
            imgUrl=@"none";
        }else if (!description.length>0) {
              description=@"none";
        }
        
        NSLog(@"%@",description);

    NSString *databasePath = [self databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
  //  [database executeUpdate:@"INSERT INTO news_table (title,discription,pubDate,imageUrl) VALUES (?,?,?,?);",title,description,pubdate,imgUrl];
        
        
        [database executeUpdate:@"INSERT INTO news_table (title,discription,pubDate,imageUrl) SELECT ?,?,?,? WHERE NOT EXISTS(SELECT title FROM news_table WHERE title = ?);",title,description,pubdate,imgUrl,title];
    [database close];
    }

 [[NSNotificationCenter defaultCenter] postNotificationName:@"WebserviceData" object:Dictionary userInfo:Nil];
}
-(NSString *)databasePath{
    
    NSString *documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *databasePath=[documents stringByAppendingPathComponent:@"newsdb.sqlite"];
    NSFileManager *fileManger=[NSFileManager defaultManager];
    if (![fileManger fileExistsAtPath:databasePath]) {
        NSString *bundlePath=[[NSBundle mainBundle]pathForResource:@"newsdb" ofType:@"sqlite"];
        [fileManger copyItemAtPath:bundlePath toPath:databasePath error:nil];
        
    }
    return  databasePath;
}


@end

