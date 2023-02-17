//
//  CLLocationDistance+Tonight.swift
//  Tonight
//
//  Created by Domsys on 01/03/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

extension CLLocationDistance
{
    // 100 centimeter == 1 meter
    func toCentimeter() -> CLLocationDistance
    {
        return self*1000
    }
    
    // 1 foot == 0.3048 meter
    // 1 meter == 3.2808399 feet
    func toFeet() -> CLLocationDistance
    {
        return self*3.280
    }
    
    // 1 kilometer == 1000 meters
    func toKilometer() -> CLLocationDistance
    {
        return self/1000
    }
}