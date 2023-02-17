//
//  QuestionDetailsTableViewCell.swift
//  iStackOS
//
//  Created by Marsal on 15/03/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import UIKit
import Haneke

class QuestionDetailsTableViewCell: UITableViewCell
{
    // *********************************** //
    // MARK: @IBOutlet
    // *********************************** //
    
    @IBOutlet private weak var _lblScore: UILabel!
    @IBOutlet private weak var _lblAnswersCount: UILabel!
    
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
        _lblAnswersCount.text = ""
        
        _lblBody.text = ""
        
        _lblCreationDate.text = ""
        _imgUserAvatar.image = UIImage(imageLiteral: "default-avatar")
        _lblUserDisplay.text = ""
    }

    func configureCellWithQuestion(question: Question)
    {
        // load labels and image view with question properties
        _lblScore.text = "\(question.score)"
        _lblAnswersCount.text = "\(question.answerCount)"

        do {
            // this is used to format html and show it into UILabel
            let attrStr = try NSAttributedString(
                data: question.body.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            _lblBody.attributedText = attrStr
        }
        catch {
            print("error creating attributed string")
        }
        
        _lblCreationDate.text = Utils.getDisplayForAskedDate(question.creationDate)
        _imgUserAvatar.hnk_setImageFromURL(question.owner.avatarURL)
        _lblUserDisplay.text = question.owner.displayName
    }
    
}