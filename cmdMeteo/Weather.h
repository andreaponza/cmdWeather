
#import <Foundation/Foundation.h>

@interface Weather : NSObject {
	NSString *state;
    NSString *location;
    NSString *temperature;
    NSString *weather;
    NSString *windDirection;
    NSString *windSpeed;
    NSString *pressure;
    NSString *humidity;
    NSString *sunRise;
    NSString *sunSet;
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
@property (nonatomic, copy) NSString *sunRise;
@property (nonatomic, copy) NSString *sunSet;
@property (nonatomic, copy) NSString *iconURL;

- (void)printLocation;
- (void)printIconUrl;
- (void)description;

@end
