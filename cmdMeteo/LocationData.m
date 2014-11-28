//
//  VJWhereAmI.m
//  whereami
//
//  Created by Victor Jalencas on 17/02/10.
//  Copyright 2010 Victor Jalencas All rights reserved.
//

#import "LocationData.h"


@implementation LocationData

@synthesize coordinate;

- (void) attendLocationData{
	manager = [[CLLocationManager alloc] init];
		[manager setDelegate:self];
	locationObtained = NO;
    errorOccurred = NO;

	[manager startUpdatingLocation];
	
	while (!locationObtained && !errorOccurred) {
		CFRunLoopRun();
	}
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation  {
    if (oldLocation != nil) {
        //printf("%s\n",[[NSString stringWithFormat:@"%f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude] UTF8String]);
        coordinate = newLocation.coordinate;
        locationObtained = YES;
        CFRunLoopStop(CFRunLoopGetCurrent());
    }
	
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	fprintf(stderr,"%s\n",[[NSString stringWithFormat:@"%@: %@",[error localizedDescription],[error localizedFailureReason]] UTF8String]);
	errorOccurred = YES;
	CFRunLoopStop(CFRunLoopGetCurrent());
}


@end
