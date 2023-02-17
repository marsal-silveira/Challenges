//
//  AnswerTableViewCell.swift
//  iStackOS
//
//  Created by Marsal on 15/03/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import UIKit
import Haneke

class AnswerTableViewCell: UITableViewCell
{
    // *********************************** //
    // MARK: @IBOutlet
    // *********************************** //
    
    @IBOutlet private weak var _lblScore: UILabel!
    @IBOutlet private weak var _imgAccepted: UIImageView!
    
    @IBOutlet private weak var _lblBody: UILabel!
    
    @IBOutlet private weak var _lblCreationDate: UILabel!
    @IBOutlet private weak var _imgUserAvatar: UIImageView!
    @IBOutlet private weak var _lblUserDisplay: UILabel!

    // *********************************** //
    // MARK: Load
    // *********************************** //

    override func prepareForReuse()
    {
        // just clear all ui fields
        _lblScore.text = ""
        _imgAccepted.hidden = true
        
        _lblBody.text = ""
        
        _lblCreationDate.text = ""
        _imgUserAvatar.image = UIImage(imageLiteral: "default-avatar")
        _lblUserDisplay.text = ""
    }

    func configureCellWithAnser(answer: Answer, isAccepted: Bool)
    {
        // load labels and image view with answer properties
        _lblScore.text = "\(answer.score)"
        _imgAccepted.hidden = !isAccepted
        
        do {
            // this is used to format html and show it into UILabel
            let attrStr = try NSAttributedString(
                data: answer.body.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            _lblBody.attributedText = attrStr
        }
        catch {
            print("error creating attributed string")
        }
        
        _lblCreationDate.text = Utils.getDisplayAnsweredDate(answer.creationDate)
        _imgUserAvatar.hnk_setImageFromURL(answer.owner.avatarURL)
        _lblUserDisplay.text = answer.owner.displayName
    }
    
}