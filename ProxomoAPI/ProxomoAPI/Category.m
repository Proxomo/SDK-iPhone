//
//  Category.m
//  ProxomoAPI
//
//  Created by Fred Crable on 12/9/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "Category.h"

@implementation Category
@synthesize Category;
@synthesize CategoryType;
@synthesize SubCategory;

-(NSString *) objectPath:(enumRequestType)requestType{
    return  @"category";
}

@end
