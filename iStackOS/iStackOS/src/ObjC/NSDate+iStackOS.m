#import "NSDate+iStackOS.h"

@implementation NSDate (iStackOS)

#pragma mark - Utils

//! return a date formatter instance with custom dateFormat
+ (NSDateFormatter *)getDateFormatterWithDateFormat:(NSString *)dateFormat
{
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"]];
    }
    [formatter setDateFormat:dateFormat];
    return formatter;
}

//! Default value... return a date formatter instance with dateFormat = 'yyyy-MM-dd HH:mm:ss'
+ (NSDateFormatter *)getDateFormatter
{
    return [self getDateFormatterWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark - Class Methods

//! return the initial date ("1900-01-01 00:00:00") as string value
+ (NSString *)firstDateAsString
{
    return @"1900-01-01 00:00:00";
}

//! create a new NSDate instance and return it formated with 'yyyy-MM-dd HH:mm:ss'
+ (NSDate *)dateFormated
{
    return [NSDate stringToDate:[[NSDate date] dateTimeToString]];
}

//! convert a date from string to NSDate object. The data value must be with 'yyyy-MM-dd HH:mm:ss' format
+ (NSDate *)stringToDate:(NSString *)string
{
    return [[self getDateFormatter] dateFromString:string];
}

//! return the NString value of the first day of the current week. This will return a string in 'yyyy-MM-dd' format
+ (NSString *)firstCurrentWeekDayToString
{
    // get start of week
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startOfWeek;
    [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&startOfWeek interval:NULL forDate:[NSDate date]];
    return [[self getDateFormatterWithDateFormat:@"yyyy-MM-dd"] stringFromDate:startOfWeek];
}

#pragma mark - Instance Methods

//! convert NSDate value (date time) into a NSString value using 'yyyy-MM-dd HH:mm:ss' format
- (NSString *)dateTimeToString
{
    return [[NSDate getDateFormatter] stringFromDate:self];
}

//! extract date value an return it as NSString value using 'yyyy-MM-dd' format
- (NSString *)dateToString
{
    return [[NSDate getDateFormatterWithDateFormat:@"yyyy-MM-dd"] stringFromDate:self];
}

//! extract time value an return it as NSString value using 'HH:mm:ss' format
- (NSString *)timeToString
{
    return [[NSDate getDateFormatterWithDateFormat:@"HH:mm:ss"] stringFromDate:self];
}

//! extract hour an return it as NSString value using 'HH' format
- (NSString *)hourToString
{
    return [[NSDate getDateFormatterWithDateFormat:@"HH"] stringFromDate:self];
}

//! extract day an return it as NSString value using 'dd' format
- (NSString *)dayToString
{
    return [[NSDate getDateFormatterWithDateFormat:@"dd"] stringFromDate:self];
}

//! extract month number an return it as NSString value using 'MM' format
- (NSString *)monthNumberToString
{
    return [[NSDate getDateFormatterWithDateFormat:@"MM"] stringFromDate:self];
}

//! extract year an return it as NSString value using 'yyyy' format
- (NSString *)yearToString
{
    return [[NSDate getDateFormatterWithDateFormat:@"yyyy"] stringFromDate:self];
}

@end