//
//  Logger.swift
//  iStackOS
//
//  Created by Marsal on 13/03/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import Foundation

class Logger
{
    static func log(logMessage: String = "", file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__)
    {
        // __FILE__ : String - The name of the file in which it appears.
        // __FUNCTION__ : String - The name of the declaration in which it appears.
        // __LINE__ : Int - The line number on which it appears.
        
        let fileURL = NSURL(fileURLWithPath: file)
        let className = fileURL.lastPathComponent!.stringByReplacingOccurrencesOfString(fileURL.pathExtension!, withString: "")
        print("[\(className)\(function)][\(line)] \(logMessage)")
    }
}