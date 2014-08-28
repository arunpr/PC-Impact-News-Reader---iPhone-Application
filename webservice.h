//
//  webservice.h
//  News
//
//  Created by Palani  on 12/23/13.
//  Copyright (c) 2013 Palani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"
@interface webservice : NSObject<NSXMLParserDelegate>
{
    NSString *newsTypeString;
    NSMutableData *  webData;
    NSString *currentData;
    NSURLConnection * connetion1;
    NSDictionary *dic;
}
@property(strong,nonatomic)    NSDictionary *Dictionary;

-(void)Startconnection:(NSString *)urlString ;

@end
