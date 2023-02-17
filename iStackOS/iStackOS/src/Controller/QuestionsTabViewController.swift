//
//  QuestionsTabViewController.swift
//  iStackOS
//
//  Created by Marsal on 13/03/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import UIKit

class QuestionsTabViewController: UITableViewController
{
    // ********************************** //
    // MARK: Properties
    // ********************************** //
        
    private var _questions = [Question]()
    private var _selectedQuestion: Question!
    
    // ********************************** //
    // MARK: @IBOutlet
    // ********************************** //
    
    @IBOutlet weak var btnRefresh: UIBarButtonItem!
    
    // ********************************** //
    // MARK: @IBAction
    // ********************************** //
    
    @IBAction func btnRefreshTap(sender: UIBarButtonItem)
    {
        self.loadData()
    }
    
    // ********************************** //
    // MARK: <UIViewController> Lifecycle
    // ********************************** //

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        self.title = self.parentViewController?.title
        
        //
        self.loadData()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.deselectAllRows()
    }
    
    // ********************************** //
    // MARK: Utils
    // ********************************** //
    
    func deselectAllRows()
    {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            
            for indexPath in selectedRows {
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == STORYBOARD_SEGUE_PreviewToDetails) {
            let viewController = segue.destinationViewController as! QuestionDetailsTableViewController
            viewController.question = _selectedQuestion
        }
    }
    
    // ********************************** //
    // MARK: <UITableViewDataSource>
    // ********************************** //

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return _questions.count
    }
    
    // *********************************** //
    // MARK: <UITableViewDelegate>
    // *********************************** //
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 110
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var result: QuestionPreviewTableViewCell
        if let cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER_Question_Preview) as? QuestionPreviewTableViewCell {
            result = cell
        }
        else {
            result = QuestionPreviewTableViewCell()
        }
        result.configureCellWithQuestion(_questions[indexPath.row])
        
        return result
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        _selectedQuestion = _questions[indexPath.row]
        performSegueWithIdentifier(STORYBOARD_SEGUE_PreviewToDetails, sender: self)
    }
    
    // ********************************** //
    // MARK: Load Data
    // ********************************** //
    
    private func loadData()
    {
        // only continue if device has network connection...
        if (isConnectedToNetwork()) {

            // get tag filter using parentViewController... Each view controller is associated to one tag filter value...
            if let restorationIdentifier = self.parentViewController?.restorationIdentifier, let tagFilter = StackOverflowTag(rawValue: restorationIdentifier) {
                
                // disable refresh button to avoid exec more than one refresh process...
                btnRefresh.enabled = false
                
                DataSource.sharedInstance().fetchQuestionsWithTag(tagFilter, successBlock: {
                    questions in
                    
                    // update questions internal list and refresh data
                    self._questions = questions
                    self.tableView.reloadData()
                    
                    // enabled refresh button again...
                    self.btnRefresh.enabled = true
                    },
                    failureBlock: {
                        errro in
                        
                        // TODO: check error type to handle it accordlly
                        self._questions = []
                        
                        // enabled refresh button again...
                        self.btnRefresh.enabled = true
                })
            }
            else {
                let tagValue = self.parentViewController?.restorationIdentifier
                Utils.showSimpleAlertWithTitle("Opps!", message: String.localizedStringWithFormat(NSLocalizedString("[Invalid Tag]", comment: ""), tagValue!), viewController: self)
            }
        }
        else {
            Utils.showSimpleAlertWithTitle("Opps!", message: NSLocalizedString("[Internet Connection Not Found]", comment: ""), viewController: self)
        }
    }

}