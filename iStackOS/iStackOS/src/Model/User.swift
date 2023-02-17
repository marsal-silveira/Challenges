//
//  User.swift
//  iStackOS
//
//  Created by Marsal on 13/03/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import Foundation
import Gloss

public struct User: Decodable
{
    // ****************************** //
    // MARK: Properties
    // ****************************** //
    
    //stored...
    private var _id: Int
    var id: Int {
        return _id
    }

    private var _displayName: String
    var displayName: String {
        return _displayName
    }
    
    private var _profileImage: String
    var profileImage: String {
        return _profileImage
    }
    
    // temporal...
    private var _avatarURL: NSURL
    var avatarURL: NSURL {
        return _avatarURL
    }

    // ****************************** //
    // MARK: Init
    // ****************************** //
    
    public init?(json: JSON)
    {
        guard let id: Int = "user_id" <~~ json,
            let displayName: String = "display_name" <~~ json,
            let profileImage: String = "profile_image" <~~ json else {
                return nil
        }

        // storage...
        _id = id
        _displayName = displayName
        _profileImage = profileImage
        
        // temporal...
        _avatarURL = NSURL(string: _profileImage)!
    }
    
}