//
//  Utils.swift
//  iStackOS
//
//  Created by Marsal on 13/03/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import UIKit

struct Utils
{
    
    private enum DateType
    {
        case Asked
        case Answered
    }
    
    static func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(action)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func getDisplayForAskedDate(askedDate: NSDate) -> String?
    {
        return getDisplayForDate(.Asked, date: askedDate)
    }
    
    static func getDisplayAnsweredDate(answeredDate: NSDate) -> String?
    {
        return getDisplayForDate(.Answered, date: answeredDate)
    }
    
    private static func getDisplayForDate(dateType: DateType, date: NSDate) -> String?
    {
        var result: String? = nil;
        
        // if asked today = "Asked XX hours ago"
        if (date.dateToString() == NSDate().dateToString()) {
            
            let calendar = NSCalendar.currentCalendar()
            
            // get creation and current hour and minute
            var components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: date)
            let creationHour = components.hour
            let creationMinute = components.minute
            components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: NSDate())
            let currentHour = components.hour
            let currentMinute = components.minute
            
            //
            var period = 0
            var periodStr: String! = nil
            if (creationHour != currentHour) {
                period = currentHour-creationHour
                periodStr = "\(period) \(period == 1 ? NSLocalizedString("[hour]", comment: "") : NSLocalizedString("[hours]", comment: ""))"
            }
            else {
                period = currentMinute-creationMinute
                periodStr = "\(period) \(period == 1 ? NSLocalizedString("[minute]", comment: "") : NSLocalizedString("[minutes]", comment: ""))"
            }
            result = dateType == .Asked ? "[Asked Today]" : "[Answered Today]"
            result = String.localizedStringWithFormat(NSLocalizedString(result!, comment: ""), periodStr)
        }
            // if asked yesterday = "Asked yesterday at hh:mm:ss"
        else if (date.dateToString() == Utils.getYesterday().dateToString()) {
            result = dateType == .Asked ? "[Asked Yesterday]" : "[Answered Yesterday]"
            result = String.localizedStringWithFormat(NSLocalizedString(result!, comment: ""), date.timeToString())
        }
            // otherwise = "Asked at dd de MMMM de yyyy"
        else {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            result = dateType == .Asked ? "[Asked Month]" : "[Answered Month]"
            result = String.localizedStringWithFormat(NSLocalizedString(result!, comment: ""), formatter.stringFromDate(date))
        }
        return result;
    }
    
    private static func getYesterday() -> NSDate
    {
        let now = NSDate()
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: now)
        components.day = -1
        
        // create a calendar and return yesterday NSDate value
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        return (gregorian?.dateByAddingComponents(components, toDate: now, options:NSCalendarOptions(rawValue: 0)))!
    }
}