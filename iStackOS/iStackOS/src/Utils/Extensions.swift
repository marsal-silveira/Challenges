//
//  Extensions.swift
//  iStackOS
//
//  Created by Marsal on 16/03/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import Foundation

extension Int
{
    func toBoolean() -> Bool?
    {
        if (self == 0) {
            return false
        }
        else if (self == 1) {
            return true
        }
        else {
            return nil
        }
    }
}