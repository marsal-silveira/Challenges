//
//  Answer.swift
//  iStackOS
//
//  Created by Marsal on 15/03/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import Foundation
import Gloss

public struct Answer: Decodable
{
    // ****************************** //
    // MARK: Properties
    // ****************************** //
    
    private var _id: Int
    public var id: Int {
        return _id
    }
    
    private var _questionID: Int
    public var questionID: Int {
        return _questionID
    }
    
    private var _isAccepted: Bool
    public var isAccepted: Bool {
        return _isAccepted
    }
    
    private var _score: Int
    var score: Int {
        return _score
    }
    
    private var _creationDate: NSDate
    var creationDate: NSDate {
        return _creationDate
    }
    
    private var _lastActivityDate: NSDate
    var lastActivityDate: NSDate {
        return _lastActivityDate
    }
    
    private var _body: String
    var body: String {
        return _body
    }
    
    private var _owner: User
    var owner: User {
        return _owner
    }
    
    // ****************************** //
    // MARK: Init
    // ****************************** //
    
    public init?(json: JSON)
    {
        guard let id: Int = "answer_id" <~~ json,
            let questionID: Int = "question_id" <~~ json,
            let isAccepted: Int = "is_accepted" <~~ json,
            let score: Int = "score" <~~ json,
            let creationDateTimeInterval: NSTimeInterval = "creation_date" <~~ json,
            let lastActivityDateTimeInterval: NSTimeInterval = "last_activity_date" <~~ json,
            let body: String = "body" <~~ json,
            let owner: User = "owner" <~~ json else {
                return nil
        }
        
        _id = id
        _questionID = questionID
        _isAccepted = isAccepted.toBoolean()!
        _score = score
        _creationDate = NSDate(timeIntervalSince1970: creationDateTimeInterval)
        _lastActivityDate = NSDate(timeIntervalSince1970: lastActivityDateTimeInterval)
        _body = body
        _owner = owner
    }
    
}