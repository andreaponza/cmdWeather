
#import <Foundation/Foundation.h>
#import "Weather.h"

@interface WeatherFetcher : NSObject <NSXMLParserDelegate> {
    NSString *locationString;
    NSString *urlStr;
    NSString *tempstr;
	NSMutableArray *classes;
	NSMutableString *currentString;
	NSMutableDictionary *currentFields;
	NSDateFormatter *dateFormatter;
    Weather *currentClass;
}

@property NSString *locationString;
// Returns an NSArray of ScheduledClass objects if successful.
// Returns nil on failure.
- (NSArray *)fetchClassesWithError:(NSError **)outError;

@end
