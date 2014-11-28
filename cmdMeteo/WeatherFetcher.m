
#import "WeatherFetcher.h"


#define url "http://api.openweathermap.org/data/2.5/weather?"
#define parameter "&mode=xml&units=metric"
#define icon "http://openweathermap.org/img/w/"

@implementation WeatherFetcher

@synthesize locationString;

- (id)init {
	self = [super init];
	if (self) {
		classes = [[NSMutableArray alloc] init];
        currentClass = [[Weather alloc] init];
        locationString = [[NSString alloc]init];
        currentFields=[[NSMutableDictionary alloc]init];
	}
	return self;
}
- (NSArray *)fetchClassesWithError:(NSError **)outError
{
    //define url string
    NSMutableString *urlString = [[NSMutableString alloc]initWithString:@url];
    [urlString appendString:locationString];
    [urlString appendString:@parameter];
    urlStr = urlString;
    //NSLog(@"%@", urlStr);
    
	BOOL success;
	
	NSURL *xmlURL = [NSURL URLWithString:
					 urlStr];
	NSURLRequest *req = [NSURLRequest requestWithURL:xmlURL
										 cachePolicy:NSURLRequestReturnCacheDataElseLoad
									 timeoutInterval:30];
	NSURLResponse *resp = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:req
										  returningResponse:&resp
													  error:outError];
    if (!data){
        printf("No data\n");
        return nil;
    }
    //NSLog(@"Received %ld bytes.", [data length]);
	
	[classes removeAllObjects];
	
	NSXMLParser *parser;
	parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	success = [parser parse];
	if (!success)
	{
		*outError = [parser parserError];
		return nil;
	}
	NSArray *output = [classes copy];
	return output;
}

#pragma mark XML parser delegate

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
   attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"country"]) {
        currentString = [[NSMutableString alloc]init];
    }
    if ([elementName isEqual:@"city"]) {
        [currentFields setObject:[attributeDict objectForKey:@"name"] forKey:@"city"];
    }
    if ([elementName isEqual:@"temperature"]) {
        [currentFields setObject:[attributeDict objectForKey:@"value"] forKey:@"temperature"];
    }
    if ([elementName isEqual:@"speed"]) {
        [currentFields setObject:[attributeDict objectForKey:@"value"]forKey:@"speed"];
    }
    if ([elementName isEqual:@"direction"]) {
        [currentFields setObject:[attributeDict objectForKey:@"name"]forKey:@"direction"];
    }
    if ([elementName isEqual:@"pressure"]) {
        [currentFields setObject:[attributeDict objectForKey:@"value"]forKey:@"pressure"];
    }
    if ([elementName isEqual:@"humidity"]) {
        [currentFields setObject:[attributeDict objectForKey:@"value"]forKey:@"humidity"];
    }
    if ([elementName isEqual:@"weather"]) {
        [currentFields setObject:[attributeDict objectForKey:@"value"]forKey:@"weather"];
        [currentFields setObject:[attributeDict objectForKey:@"icon"]forKey:@"icon"];
        
    }
    if ([elementName isEqualToString:@"sun"]) {
        [currentFields setObject:[attributeDict objectForKey:@"rise"]forKey:@"sunRise"];
        [currentFields setObject:[attributeDict objectForKey:@"set"]forKey:@"sunSet"];
    }
  
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(!currentString){
        currentString = [[NSMutableString alloc] init];
	}
    
    [currentString appendString:string];
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqual:@"country"]) {
        [currentClass setState:currentString];
    }
    if ([elementName isEqual:@"temperature"]) {
        [currentClass setTemperature:[currentFields objectForKey:@"temperature"]];
    }
    if ([elementName isEqual:@"city"]) {
        [currentClass setLocation:[currentFields objectForKey:@"city"]];
    }
    if ([elementName isEqual:@"speed"]) {
        [currentClass setWindSpeed:[currentFields objectForKey:@"speed"]];
    }
    if ([elementName isEqual:@"direction"]) {
        [currentClass setWindDirection:[currentFields objectForKey:@"direction"]];
    }
    if ([elementName isEqual:@"pressure"]) {
        [currentClass setPressure:[currentFields objectForKey:@"pressure"]];
    }
    if ([elementName isEqual:@"humidity"]) {
        [currentClass setHumidity:[currentFields objectForKey:@"humidity"]];
    }
    if ([elementName isEqual:@"sun"]) {
        NSString *tmpString = [[currentFields objectForKey:@"sunRise"] substringWithRange: NSMakeRange(11,5)];
        [currentClass setSunRise:tmpString];
        tmpString = [[currentFields objectForKey:@"sunSet"] substringWithRange: NSMakeRange(11,5)];
        [currentClass setSunSet:tmpString];
        
    }
    if ([elementName isEqual:@"weather"]) {
        [currentClass setWeather:[currentFields objectForKey:@"weather"]];
        NSMutableString *iUrl = [[NSMutableString alloc]initWithString:@icon];
        [iUrl appendString:[currentFields objectForKey:@"icon"]];
        [iUrl appendString:@".png"];
        [currentClass setIconURL:iUrl];
        [classes addObject:currentClass];
    }
    
}

@end
