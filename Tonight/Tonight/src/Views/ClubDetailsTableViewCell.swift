//
//  ClubDetailsTableViewCell.swift
//  Tonight
//
//  Created by Marsal on 29/02/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import UIKit
import Haneke

class ClubDetailsTableViewCell: UITableViewCell
{
    // *********************************** //
    // MARK: Property
    // *********************************** //
    
    private var _clubSiteURL: NSURL?

    // *********************************** //
    // MARK: @IBOutlet
    // *********************************** //

    @IBOutlet private weak var _imgViewPhoto: UIImageView!
    @IBOutlet private weak var _lblName: UILabel!
    @IBOutlet private weak var _lblAddress: UILabel!
    @IBOutlet private weak var _lblDistance: UILabel!
    @IBOutlet private weak var _lblPhone: UILabel!
    
    // *********************************** //
    // MARK: @IBAction
    // *********************************** //
    
    @IBAction func btnGoToSiteTap(sender: UIButton)
    {
        if let url = _clubSiteURL {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    // *********************************** //
    // MARK: Utils
    // *********************************** //
    
    override func prepareForReuse()
    {
        // just clear all ui fields
        _imgViewPhoto.image = NoImageSingleton.placeholderImageView
        _lblName.text = ""
        _lblAddress.text = ""
        _lblDistance.text = ""
        _lblPhone.text = ""
    }
    
    func configureCell(club: Club)
    {
        var distanceFromUser: String = ""
        if let distance = club.distance {
            distanceFromUser = "\(String(format: "%.1f", distance.toKilometer())) km"
        }

        // load labels and image view with club properties
        _imgViewPhoto.hnk_setImageFromURL(club.logoURL)
        _lblName.text = club.name
        _lblAddress.text = club.address
        _lblDistance.text = distanceFromUser
        _lblPhone.text = club.phone
        
        // storage site url to open
        _clubSiteURL = NSURL(string: club.site)
    }

}