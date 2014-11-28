
#import "Weather.h"

@implementation Weather

@synthesize state,
            location,
            weather,
            temperature,
            windDirection,
            windSpeed,
            pressure,
            humidity,
            sunRise,
            sunSet,
            iconURL;

- (void)printLocation{
    printf("%s %s\n", [location cStringUsingEncoding:NSUTF8StringEncoding],
           [state cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void)printIconUrl{
    printf("%s", [iconURL cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void)description {
    //Convert meter for second to knots
    double intWSpeed = [windSpeed doubleValue]*1.94384449;
    
    printf("Weather condition for %s %s\n", [location cStringUsingEncoding:NSUTF8StringEncoding],
           [state cStringUsingEncoding:NSUTF8StringEncoding]);
    
    printf("Situation: %s\n", [weather cStringUsingEncoding:NSUTF8StringEncoding]);
    printf("Temperature: %dC°\n", [temperature intValue]);
    printf("Wind: %s %dknots\n", [windDirection cStringUsingEncoding:NSUTF8StringEncoding], (int)intWSpeed);
    printf("Pressure: %dhPa\n", [pressure intValue]);
    printf("Humidity: %d%%\n", [humidity intValue]);
    printf("Sun: ↑%sam ↓%spm\n", [sunRise cStringUsingEncoding:NSUTF8StringEncoding], [sunSet cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
