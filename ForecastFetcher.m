
#import "ForecastFetcher.h"


#define url "http://api.openweathermap.org/data/2.5/forecast?"
#define parameter "&mode=xml&units=metric"

@implementation ForecastFetcher

@synthesize locationString;

- (id)init {
	self = [super init];
	if (self) {
		classes = [[NSMutableArray alloc] init];
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:@"dd-MM-yyyy 'at' HH:mm"];
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
    if ([elementName isEqual:@"time"]) {
        currentFields = [[NSMutableDictionary alloc] init];
        [currentFields setObject:[attributeDict objectForKey:@"from"] forKey:@"timeFrom"];
        [currentFields setObject:[attributeDict objectForKey:@"to"] forKey:@"timeTo"];
    }
    else if ([elementName isEqual:@"symbol"]) {
        [currentFields setObject:[attributeDict objectForKey:@"name"] forKey:@"weather"];
        [currentFields setObject:[attributeDict objectForKey:@"var"]forKey:@"icon"];
    }
    else if ([elementName isEqual:@"temperature"]) {
        [currentFields setObject:[attributeDict objectForKey:@"value"] forKey:@"temperature"];
    }
    else if ([elementName isEqual:@"windDirection"]) {
        [currentFields setObject:[attributeDict objectForKey:@"name"] forKey:@"windDirection"];
    }
    else if ([elementName isEqual:@"windSpeed"]) {
        [currentFields setObject:[attributeDict objectForKey:@"mps"] forKey:@"windSpeed"];
    }
    else if ([elementName isEqual:@"pressure"]) {
        [currentFields setObject:[attributeDict objectForKey:@"value"] forKey:@"pressure"];
    }
    else if ([elementName isEqual:@"humidity"]) {
        [currentFields setObject:[attributeDict objectForKey:@"value"] forKey:@"humidity"];
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
    if ([elementName isEqual:@"time"]) {
        Forecast *currentClass = [[Forecast alloc] init];
        [currentClass setWeather:[currentFields objectForKey:@"weather"]];
        [currentClass setTemperature:[currentFields objectForKey:@"temperature"]];
        [currentClass setWindDirection:[currentFields objectForKey:@"windDirection"]];
        [currentClass setWindSpeed:[currentFields objectForKey:@"windSpeed"]];
        [currentClass setPressure:[currentFields objectForKey:@"pressure"]];
        [currentClass setHumidity:[currentFields objectForKey:@"humidity"]];
        
        NSDate *tmp = [NSDate dateWithNaturalLanguageString:[currentFields objectForKey:@"timeFrom"]];
        [currentClass setFromDate:[dateFormatter stringFromDate:tmp]];
        
        tmp = [NSDate dateWithNaturalLanguageString:[currentFields objectForKey:@"timeTo"]];
        [currentClass setToDate:[dateFormatter stringFromDate:tmp]];
        
        NSMutableString *iUrl = [[NSMutableString alloc]initWithString:[currentFields objectForKey:@"icon"]];
        //[iUrl appendString:[currentFields objectForKey:@"icon"]];
        [iUrl appendString:@".png"];
        [currentClass setIconURL:iUrl];
        
        [classes addObject:currentClass];
    }
}

@end
