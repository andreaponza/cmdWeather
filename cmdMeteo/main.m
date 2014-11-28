//
//  main.m
//  cmdMeteo
//
//  Created by Andrea on 22/12/13.
//  Copyright (c) 2013 Tuttologico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherFetcher.h"
#import "Weather.h"
#import "ForecastFetcher.h"
#import "Forecast.h"
#import "LocationData.h"


int main(int argc, const char * argv[])
{
    NSError *error;
    NSString *location;
    NSMutableString *tmp = [[NSMutableString alloc]init];
    NSString *forecast = @"-f";
    NSString *autolocation = @"-a";
    NSString *autolocationIcon = @"-ai";
    NSString *icon = @"-i";
    
    @autoreleasepool
    {
        if (argc == 1) {
            printf("Command line weather data Ver. 2.0\n");
            printf("Weather data by openweathermap.org\n");
            printf("No location set\nProvide valid location\n");
            printf("-a parameter for autolocation\n");
            printf("-f parameter for forecast data\n");
            printf("-ai parameter for autolocation icon URL\n");
            printf("-i parameter for icon URL\n");
            printf("Dowload update from http://tuttologico.altervista.org/cweather-il-meteo-da-terminale-con-osx/\nReport bug to tuttologico@icloud.com\n");
            return 0;
        }
        else
        {
            location = [NSString stringWithUTF8String:argv[1]];
            
            int index = 0;
            if ([location isEqual:forecast]) index = 1;
            if ([location isEqual:autolocation]) index = 2;
            if ([location isEqual:icon]) index = 3;
            if ([location isEqual:autolocationIcon]) index = 4;
            
            
            switch (index) {
                case 1://Forecast
                {
                    if (argc == 2)
                    {
                        printf("Set valid location\n");
                        break;
                    }
                    location = [NSString stringWithUTF8String:argv[2]];
                    
                    if (argc > 3)
                    {
                        for (int i = 2; i < argc; i++)
                        {
                            [tmp appendString:[NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding]];
                            if(i < argc-1){
                                [tmp appendString:@"_"];
                            }
                        }
                        location = tmp;
                    }
                    
                    tmp = [NSMutableString stringWithFormat:@"q=%@", location];
                    location = tmp;
                    
                    ForecastFetcher *ff = [[ForecastFetcher alloc]init];
                    [ff setLocationString:location];
                    NSArray *forecastData = [ff fetchClassesWithError:&error];
                    WeatherFetcher *wf = [[WeatherFetcher alloc]init];
                    [wf setLocationString:location];
                    NSArray *weatherData = [wf fetchClassesWithError:&error];
                    Weather *getLocation = [weatherData objectAtIndex:0];
                    
                    printf("Weather forecast for ");
                    [getLocation printLocation];
                    printf("Time                                      Situation            Temp  Wind Direction     Speed    Press.   Hum.\n");
                    
                    for(Forecast *fd in forecastData)
                    {
                        [fd description];
                        printf("\n");
                    }
                    break;
                }
                
                case 2://Autolocation
                {
                    if (argc > 2) {
                        printf("-a parameter must no be no argument\n");
                        break;
                    }
                    
                    LocationData *locationData = [[LocationData alloc]init];
                    [locationData attendLocationData];
                    location = [NSString stringWithFormat:@"lat=%f&lon=%f", locationData.coordinate.latitude, locationData.coordinate.longitude];
                    //NSLog(@"%@", location);
                    WeatherFetcher *wf = [[WeatherFetcher alloc]init];
                    [wf setLocationString:location];
                    NSArray *weatherData = [wf fetchClassesWithError:&error];
                    for(Weather *wd in weatherData)
                    {
                        [wd description];
                    }
                    break;
                }
                    
                case 3://Icon URL
                {
                    if (argc == 2)
                    {
                        printf("Set valid location\n");
                        break;
                    }
                    
                    location = [NSString stringWithUTF8String:argv[2]];
                    
                    if (argc > 3)
                    {
                        for (int i = 2; i < argc; i++)
                        {
                            [tmp appendString:[NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding]];
                            if(i < argc-1){
                                [tmp appendString:@"_"];
                            }
                        }
                        location = tmp;
                    }
                    
                    tmp = [NSMutableString stringWithFormat:@"q=%@", location];
                    location = tmp;
                    WeatherFetcher *wf = [[WeatherFetcher alloc]init];
                    [wf setLocationString:location];
                    NSArray *weatherData = [wf fetchClassesWithError:&error];
                    Weather *getLocation = [weatherData objectAtIndex:0];
                    [getLocation printIconUrl];
                    break;
                }
                    
                case 4://Autolocation icon URL
                {
                    if (argc > 2) {
                        printf("-ai parameter must no be no argument\n");
                        break;
                    }
                    LocationData *locationData = [[LocationData alloc]init];
                    [locationData attendLocationData];
                    location = [NSString stringWithFormat:@"lat=%f&lon=%f", locationData.coordinate.latitude, locationData.coordinate.longitude];
                    //NSLog(@"%@", location);
                    WeatherFetcher *wf = [[WeatherFetcher alloc]init];
                    [wf setLocationString:location];
                    NSArray *weatherData = [wf fetchClassesWithError:&error];
                    Weather *getLocation = [weatherData objectAtIndex:0];
                    [getLocation printIconUrl];
                    break;
                }
                    
                default: //Default, no parameter only location
                {
                    location = [NSString stringWithUTF8String:argv[1]];
                    
                    if (argc > 2)
                    {
                        for (int i = 1; i < argc; i++)
                        {
                            [tmp appendString:[NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding]];
                            if(i < argc-1){
                                [tmp appendString:@"_"];
                            }
                        }
                        location = tmp;
                        
                    }
                    
                    tmp = [NSMutableString stringWithFormat:@"q=%@", location];
                    location = tmp;
                    
                    WeatherFetcher *wf = [[WeatherFetcher alloc]init];
                    [wf setLocationString:location];
                    NSArray *weatherData = [wf fetchClassesWithError:&error];
                    for(Weather *wd in weatherData)
                    {
                        [wd description];
                    }
                    break;
                }
                    
            }
            
            return  0;
        }
    }
}




