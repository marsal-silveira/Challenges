#import <Foundation/Foundation.h>

@interface NSDate (iStackOS)

#pragma mark - Class Methods

//! return the initial date ("1900-01-01 00:00:00") as string value
+ (NSString *)firstDateAsString;

//! create a new NSDate instance and return it formated with 'yyyy-MM-dd HH:mm:ss'
+ (NSDate *)dateFormated;

//! convert a date from string to NSDate object. The data value must be with 'yyyy-MM-dd HH:mm:ss' format
+ (NSDate *)stringToDate:(NSString *)string;

//! return the NString value of the first day of the current week. This will return a string in 'yyyy-MM-dd' format
+ (NSString *)firstCurrentWeekDayToString;

#pragma mark - Instance Methods

//! convert NSDate value (date time) into a NSString value using 'yyyy-MM-dd HH:mm:ss' format
- (NSString *)dateTimeToString;

//! extract date value an return it as NSString value using 'yyyy-MM-dd' format
- (NSString *)dateToString;

//! extract time value an return it as NSString value using 'HH:mm:ss' format
- (NSString *)timeToString;

//! extract hour an return it as NSString value using 'HH' format
- (NSString *)hourToString;

//! extract day an return it as NSString value using 'dd' format
- (NSString *)dayToString;

//! extract month number an return it as NSString value using 'MM' format
- (NSString *)monthNumberToString;

//! extract year an return it as NSString value using 'yyyy' format
- (NSString *)yearToString;

@end