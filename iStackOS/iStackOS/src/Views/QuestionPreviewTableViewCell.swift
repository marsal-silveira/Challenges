//
//  QuestionPreviewTableViewCell.swift
//  iStackOS
//
//  Created by Marsal on 13/03/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import UIKit
import Haneke

class QuestionPreviewTableViewCell: UITableViewCell
{
    // *********************************** //
    // MARK: @IBOutlet
    // *********************************** //
    
    @IBOutlet private weak var _lblScore: UILabel!
    @IBOutlet private weak var _lblAnswersCount: UILabel!
    
    @IBOutlet private weak var _lblTitle: UILabel!

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
        
        _lblTitle.text = ""
        
        _lblCreationDate.text = ""
        _imgUserAvatar.image = UIImage(imageLiteral: "default-avatar")
        _lblUserDisplay.text = ""
    }

    func configureCellWithQuestion(question: Question)
    {
        // load labels and image view with club properties
        _lblScore.text = "\(question.score)"
        _lblAnswersCount.text = "\(question.answerCount)"
        
        _lblTitle.text = question.title
        
        _lblCreationDate.text = Utils.getDisplayForAskedDate(question.creationDate)
        _imgUserAvatar.hnk_setImageFromURL(question.owner.avatarURL)
        _lblUserDisplay.text = question.owner.displayName
    }

}