//
//  LocationDelegate.h
//  MapIT
//
//  Created by Natasha Murashev on 5/20/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationDelegate <NSObject>

- (void)displayLocation:(NSDictionary *)locationDictionary;

@end
