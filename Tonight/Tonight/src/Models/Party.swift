//
//  Party.swift
//  Tonight
//
//  Created by Marsal on 29/02/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import Firebase

class Party
{
    private var _firebaseRef: Firebase!
    
    // ****************************** //
    // MARK: Properties
    // ****************************** //

    private var _title: String
    var title: String {
        return _title
    }
    
    private var _description: String
    var description: String {
        return _description
    }
    
    private var _date: String
    var date: String {
        return _date
    }
    
    private var _price: String
    var price: String {
        return _price
    }

    // ****************************** //
    // MARK: Init
    // ****************************** //
    
    init(properties: [String: AnyObject])
    {
        _title = properties["title"] as! String
        _description = properties["description"] as! String
        _date = properties["date"] as! String
        _price = properties["price"] as! String
    }
    
    init(title: String, description: String, date: String, price: String)
    {
        _title = title
        _description = description
        _date = date
        _price = price
    }
    
    // ****************************** //
    // MARK: Utils
    // ****************************** //
    
    func toJSON() -> Dictionary<String, AnyObject>
    {
        return ["title": _title, "description": _description, "date": _date, "price": _price]
    }
    
}