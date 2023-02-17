//
//  Geolocator.swift
//  Tonight
//
//  Created by Marsal on 29/02/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

struct Geolocator
{
    // *********************************** //
    // MARK: Properties
    // *********************************** //
    
    private var _locationManager: CLLocationManager

    // ****************************** //
    // MARK: Singleton and Init
    // ****************************** //
    
    private static let singleton = Geolocator()
    static func sharedInstance() -> Geolocator
    {
        return singleton
    }
    
    // this must be private to avoid init it without using singleton way
    private init()
    {
        // configure and initialize location manager
        _locationManager = CLLocationManager()
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.requestWhenInUseAuthorization()
        _locationManager.startUpdatingLocation()
    }
    
    // do nothing... this must be called in AppDelegate.application,didFinishLaunchingWithOptions to force a complete initialization
    // actually this is a WORKAROUND :)
    func start() { }
    
    // *********************************** //
    // MARK: Calculate Distance
    // *********************************** //
    
    func calculateDistanceFromCurrentLocation(target: CLLocation) -> CLLocationDistance?
    {
        if let deviceLocation = _locationManager.location {
            return deviceLocation.distanceFromLocation(target)
        }
        else {
            return nil
        }
    }
    
}