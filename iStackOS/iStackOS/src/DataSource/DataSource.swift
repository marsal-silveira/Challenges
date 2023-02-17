//
//  DataSource.swift
//  iStackOS
//
//  Created by Marsal on 13/03/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import Alamofire
import Gloss

// ****************************** //
// MARK: StackOverflowTag
// ****************************** //

enum StackOverflowTag : String
{
    case iPhone = "iphone"
    case CocoaTouch = "cocoa-touch"
    case UiKit = "uikit"
    case ObjectiveC = "objective-c"
    case Swift = "swift"
}

// ****************************** //
// MARK: DataSource
// ****************************** //

final class DataSource
{
    // ****************************** //
    // MARK: Singleton
    // ****************************** //
    
    private static let singleton = DataSource()
    static func sharedInstance() -> DataSource
    {
        return singleton
    }
    
    // this prevents others from using the default '()' initializer for this class
    private init() {}
    
    // ******************************** //
    // MARK: Properties and Constants
    // ******************************** //
    
    // SO API Base URL
    private static let SO_API_BASE_URL = "https://api.stackexchange.com/2.2/questions"
    
    // StackOverflow API URL bases
    private static let SO_API_QUESTION_URL = SO_API_BASE_URL + "?tagged=%@&page=%d&pagesize=%d&sort=%@&order=%@&filter=withbody&site=stackoverflow"
    
    // StackOverflow API URL bases
    private static let SO_API_ANSWERS_URL = SO_API_BASE_URL + "/%d/answers?sort=%@&order=%@&filter=withbody&site=stackoverflow"
    
    // ********************************** //
    // MARK: Fetch Data with filters
    // ********************************** //
    
    func fetchQuestionsWithTag(tag: StackOverflowTag, page: Int = 1, pagesize: Int = 20, sort: String = "creation", order: String = "desc", successBlock:((questions: [Question]) -> Void), failureBlock:((error: NSError) -> Void))
    {
        Logger.log("tag: \(tag.rawValue)")
        
        let url = String(format: DataSource.SO_API_QUESTION_URL, arguments: [tag.rawValue, page, pagesize, sort, order])
        Alamofire.request(.GET,  url).responseJSON {
            response in

            if (response.result.isFailure) {
                failureBlock(error: response.result.error!)
            }
            else {
                
                var questions: [Question] = []
                if let json = response.result.value, let jsonQuestions = json["items"] as? NSArray {
                    
                    for jsonQuestion in jsonQuestions {
                        
                        if let question = Question(json: jsonQuestion as! Gloss.JSON) {
                            questions.append(question)
                        }
                        // TODO: check this context... maybe return failureBlock with custom error...
//                        else {
//                            print("Error...")
//                            abort()
//                        }
                    }
                }
                else {
                    // TODO: check this context... maybe return failureBlock with custom error...
                }
                successBlock(questions: questions)
            }
        }
    }
    
    func fetchAnswersFromQuestion(question: Question, sort: String = "votes", order: String = "desc", successBlock:((answers: [Answer]) -> Void), failureBlock:((error: NSError) -> Void))
    {
        Logger.log("question: \(question.title)")
        
        let url = String(format: DataSource.SO_API_ANSWERS_URL, arguments: [question.id, sort, order])
        Alamofire.request(.GET,  url).responseJSON {
            response in
            
            if (response.result.isFailure) {
                failureBlock(error: response.result.error!)
            }
            else {
                
                var answers: [Answer] = []
                if let json = response.result.value, let jsonAnswers = json["items"] as? NSArray {
                    
                    for jsonAnswer in jsonAnswers {
                        
                        if let answer = Answer(json: jsonAnswer as! Gloss.JSON) {
                            answers.append(answer)
                        }
                        // TODO: check this context... maybe return failureBlock with custom error...
                        //                        else {
                        //                            print("Error...")
                        //                            abort()
                        //                        }
                    }
                }
                else {
                    // TODO: check this context... maybe return failureBlock with custom error...
                }
                successBlock(answers: answers)
            }
        }
    }
    
}