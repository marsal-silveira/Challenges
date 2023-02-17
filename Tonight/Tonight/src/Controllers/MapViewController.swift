//
//  MapViewController.swift
//  Tonight
//
//  Created by Marsal on 29/02/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    // *********************************** //
    // MARK: Properties
    // *********************************** //
    
    private var _club: Club!
    var club: Club {
        get { return _club }
        set(newValue) { _club = newValue }
    }
    
    // *********************************** //
    // MARK: @IBOutlet
    // *********************************** //\
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnChangeMapType: UIBarButtonItem!
    
    // *********************************** //
    // MARK: <UIViewController>
    // *********************************** //
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        self.pinLocation(_club.location)
    }
    
    // *********************************** //
    // MARK: @IBAction
    // *********************************** //
    
    @IBAction func btnChangeMapTypeTap(sender: AnyObject)
    {
        mapView.mapType = (mapView.mapType == MKMapType.Standard) ? MKMapType.Satellite : MKMapType.Standard
        btnChangeMapType.title = (mapView.mapType == MKMapType.Standard) ? "Satellite" : "Map"
    }
    
    // *********************************** //
    // MARK: Utils
    // *********************************** //

    private func pinLocation(location: CLLocation)
    {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = _club.name
        annotation.subtitle = _club.address
        self.mapView.addAnnotation(annotation)
        self.centerMapOnLocation(location)
    }
    
    private func centerMapOnLocation(location: CLLocation)
    {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2, regionRadius*2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func zoomToUserLocationInMapView(mapView: MKMapView)
    {
        if let coordinate = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
}