//
//  ProfileViewController.swift
//  Tonight
//
//  Created by Marsal on 29/02/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import UIKit
import Haneke

class ProfileViewController: UIViewController
{
    // *********************************** //
    // MARK: @IBOutlet
    // *********************************** //
    
    @IBOutlet private weak var _imgViewAvatar: UIImageView!
    @IBOutlet private weak var _lblDisplayName: UILabel!
    @IBOutlet private weak var _lblEmail: UILabel!
    
    // *********************************** //
    // MARK: <UIViewController> Lifecycle
    // *********************************** //
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadUserProperties()
    }
    
    private func loadUserProperties()
    {
        if let user = Session.sharedInstance().user {
            _lblDisplayName.text = user.name
            _lblEmail.text = user.email
            _imgViewAvatar.hnk_setImageFromURL(user.avatarURL)
        }   
    }
    
    // *********************************** //
    // MARK: @IBOutlet - logout
    // *********************************** //

    @IBAction func btnLogoutTap(sender: UIButton)
    {
        // create and configure alert to ask user confirmation to do logout
        let alert = UIAlertController(title: "Tonight!", message: "Confirm logout?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) in
            // close session (logout) and head back to Login!
            Session.sharedInstance().doLogout()
        }))
        alert.addAction(UIAlertAction(title: "Não", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}