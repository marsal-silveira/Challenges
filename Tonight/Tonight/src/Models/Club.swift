//
//  Club.swift
//  Tonight
//
//  Created by Marsal on 29/02/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import Firebase

class Club
{
    // ****************************** //
    // MARK: Properties
    // ****************************** //
    
    // stored
    private var _uid: String?
    var uid: String? {
        return _uid
    }
    
    private var _name: String
    var name: String {
        return _name
    }
    
    private var _logoPath: String
    var logoPath: String {
        return _logoPath
    }
    
    private var _address: String
    var address: String {
        return _address
    }
    
    private var _city: String
    var city: String {
        return _city
    }
    
    private var _phone: String
    var phone: String {
        return _phone
    }
    
    private var _site: String
    var site: String {
        return _site
    }
    
    private var _latitude: String
    var latitude: String {
        return _latitude
    }
    
    private var _longitude: String
    var longitude: String {
        return _longitude
    }
    
    private var _parties: [Party]?
    var parties: [Party]? {
        return _parties
    }
    
    // temporal...
    private var _logoURL: NSURL
    var logoURL: NSURL {
        return _logoURL
    }
    
    private var _location: CLLocation
    var location: CLLocation {
        return _location
    }
    
    var distance: CLLocationDistance? {
        return Geolocator.sharedInstance().calculateDistanceFromCurrentLocation(_location)
    }

    // ****************************** //
    // MARK: Init
    // ****************************** //

    init(properties: [String: AnyObject])
    {
        // stored
        _uid = nil
        _name = properties["name"] as! String
        _logoPath = properties["logoPath"] as! String
        _address = properties["address"] as! String
        _city = properties["city"] as! String
        _phone = properties["phone"] as! String
        _site = properties["site"] as! String
        _latitude = properties["latitude"] as! String
        _longitude = properties["longitude"] as! String
        
        _parties = [Party]()
        if let parties = properties["parties"] as? [AnyObject] {
            for party in parties {
                _parties!.append(Party(properties: party as! [String : AnyObject]))
            }
        }
        
        // temporal
        _logoURL = NSURL(string: _logoPath)!
        _location = CLLocation(latitude: Double(_latitude)!, longitude: Double(_longitude)!)        
    }
    
    init(uid: String? = nil, name: String, logoPath: String, address: String, city: String, phone: String, site: String, latitude: String, longitude: String, parties: [Party]?)
    {
        // stored
        _uid = uid
        _name = name
        _logoPath = logoPath
        _address  = address
        _city = city
        _phone = phone
        _site = site
        _latitude = latitude
        _longitude = longitude
        _parties = parties
        
        // temporal
        _logoURL = NSURL(string: _logoPath)!
        _location = CLLocation(latitude: Double(_latitude)!, longitude: Double(_longitude)!)
    }
    
    // ****************************** //
    // MARK: Utils
    // ****************************** //

    func toJSON() -> Dictionary<String, AnyObject>
    {
        var jsonParties = [AnyObject]()
        if let parties = _parties {
            for party in parties {
                jsonParties.append(party.toJSON())
            }
        }
        return ["name": _name, "logoPath": _logoPath, "address": _address, "city": _city, "phone": _phone, "site": _site,  "latitude": _latitude, "longitude": _longitude, "parties": jsonParties]
    }

}