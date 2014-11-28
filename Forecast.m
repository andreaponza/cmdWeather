
#import "Forecast.h"

@implementation Forecast

@synthesize state,
            location,
            weather,
            temperature,
            windDirection,
            windSpeed,
            pressure,
            humidity,
            fromDate,
            toDate,
            iconURL;


- (void)description {
    //Convert meter for second to knots
    double intWSpeed = [windSpeed doubleValue]*1.94384449;
    
    
    /*printf("%s - %s\n", [fromDate cStringUsingEncoding:NSUTF8StringEncoding],
           [toDate cStringUsingEncoding:NSUTF8StringEncoding]);
    
    printf("Situation: %s\n", [weather cStringUsingEncoding:NSUTF8StringEncoding]);
    printf("Temperature: %dC°\n", [temperature intValue]);
    printf("Wind: %s %dknots\n", [windDirection cStringUsingEncoding:NSUTF8StringEncoding], (int)intWSpeed);
    printf("Pressure: %dhPa\n", [pressure intValue]);
    printf("Humidity: %d%%\n", [humidity intValue]);*/
    
    printf("%.35s - %.35s %-20.45s %3.2dC° %-17.20s  %2.2dknots  %2.4dhPa  %.3d%%",
           [fromDate cStringUsingEncoding:NSUTF8StringEncoding],
           [toDate cStringUsingEncoding:NSUTF8StringEncoding],
           [weather cStringUsingEncoding:NSUTF8StringEncoding],
           [temperature intValue],
           [windDirection cStringUsingEncoding:NSUTF8StringEncoding],
           (int)intWSpeed,
           [pressure intValue],
           [humidity intValue]);
}

@end
