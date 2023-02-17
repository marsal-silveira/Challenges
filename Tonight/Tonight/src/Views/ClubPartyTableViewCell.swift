//
//  ClubPartyTableViewCell.swift
//  Tonight
//
//  Created by Marsal on 29/02/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import UIKit
import Haneke

class ClubPartyTableViewCell: UITableViewCell
{
    // *********************************** //
    // MARK: @IBOutlet
    // *********************************** //

    @IBOutlet private weak var _lblTitle: UILabel!
    @IBOutlet private weak var _lblDescription: UILabel!
    @IBOutlet private weak var _lblDate: UILabel!
    @IBOutlet private weak var _lblPrice: UILabel!
        
    // *********************************** //
    // MARK: Utils
    // *********************************** //
    
    override func prepareForReuse()
    {
        // just clear all ui fields
        _lblTitle.text = ""
        _lblDescription.text = ""
        _lblDate.text = ""
        _lblPrice.text = ""
    }
    
    func configureCell(party: Party)
    {
        // load labels and image view with party properties
        _lblTitle.text = party.title
        _lblDescription.text = party.description
        _lblDate.text = "Date: \(party.date)"
        _lblPrice.text = "Price: \(party.price)"
    }

}