
#import <Foundation/Foundation.h>

@interface Forecast : NSObject {
	NSString *state;
    NSString *location;
    NSString *temperature;
    NSString *weather;
    NSString *windDirection;
    NSString *windSpeed;
    NSString *pressure;
    NSString *humidity;
    NSString *fromDate;
    NSString *toDate;
    NSString *iconURL;
}
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *temperature;
@property (nonatomic, copy) NSString *weather;
@property (nonatomic, copy) NSString *windDirection;
@property (nonatomic, copy) NSString *windSpeed;
@property (nonatomic, copy) NSString *pressure;
@property (nonatomic, copy) NSString *humidity;
@property (nonatomic, copy) NSString *fromDate;
@property (nonatomic, copy) NSString *toDate;
@property (nonatomic, copy) NSString *iconURL;

- (void)description;

@end
