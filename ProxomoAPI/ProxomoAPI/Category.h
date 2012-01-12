//
//  Category.h
//  ProxomoAPI
//
//  Created by Fred Crable on 12/9/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "ProxomoObject.h"

@interface Category : ProxomoObject {
    NSString *Category;
    NSString *CategoryType;
    NSString *SubCategory;
}

@property (nonatomic, strong) NSString *Category;
@property (nonatomic, strong) NSString *CategoryType;
@property (nonatomic, strong) NSString *SubCategory;

@end
