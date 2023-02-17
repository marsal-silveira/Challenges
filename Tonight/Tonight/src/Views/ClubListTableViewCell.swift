//
//  ClubListTableViewCell.swift
//  Tonight
//
//  Created by Marsal on 29/02/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import UIKit
import Haneke

class ClubListTableViewCell: UITableViewCell
{
    // *********************************** //
    // MARK: @IBOutlet
    // *********************************** //

    @IBOutlet private weak var _imgViewPhoto: UIImageView!
    @IBOutlet private weak var _lblName: UILabel!
    @IBOutlet private weak var _lblAddress: UILabel!
    @IBOutlet private weak var _lblDistance: UILabel!
    
    // *********************************** //
    // MARK: Utils
    // *********************************** //
    
    override func prepareForReuse()
    {
        // just clear all ui fields
        _lblName.text = ""
        _lblAddress.text = ""
        _lblDistance.text = ""
        _imgViewPhoto.image = NoImageSingleton.placeholderImageView
    }
    
    func configureCell(club: Club)
    {
        var distanceFromUser: String = ""
        if let distance = club.distance {
            distanceFromUser = "\(String(format: "%.1f", distance.toKilometer())) km"
        }
        
        // load labels and image view with club properties
        _lblName.text = club.name
        // if device is an iPhone we show the city instead of all club address... this is because we have less space here and this information will be at details screen
        _lblAddress.text = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? club.city : club.address
        _lblDistance.text = distanceFromUser
        _imgViewPhoto.hnk_setImageFromURL(club.logoURL)
    }

}