//
//  ClubDetailsTableViewController.swift
//  Tonight
//
//  Created by Marsal on 29/02/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import UIKit
import Firebase

class ClubDetailsTableViewController : UITableViewController
{
    // ****************************** //
    // MARK: Properties
    // ****************************** //
    
    private var _club: Club!
    var club: Club {
        get { return _club }
        set(newValue) { _club = newValue }
    }
    
    // *********************************** //
    // MARK: <UIViewController> Lifecycle
    // *********************************** //
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // update title with selected club name
        self.navigationItem.title = "\(_club.name)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == Segue_DetailToMap) {
            let viewController = segue.destinationViewController as! MapViewController
            viewController.club = _club
        }
    }
    
    // *********************************** //
    // MARK: <UITableViewDataSource>
    // *********************************** //
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // section 1) Details
        // section 2) Parties
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var result = 0
        if section == 0 {
            result = 1
        }
        else if let parties = _club.parties {
            result = parties.count
        }
        return result
    }
    
    // *********************************** //
    // MARK: <UITableViewDelegate>
    // *********************************** //
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (indexPath.section == 0) {
            return 180
        }
        else {
            return 120
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            return self.cellForDetails()
        }
        else {
            return self.cellForPartyAtIndexPath(indexPath)
        }
    }
    
    private func cellForDetails() -> ClubDetailsTableViewCell
    {
        var result: ClubDetailsTableViewCell!
        if let cell = tableView.dequeueReusableCellWithIdentifier(Cell_Identifier_ClubHeaderCell) as? ClubDetailsTableViewCell {
            result = cell
        }
        else {
            result = ClubDetailsTableViewCell()
        }
        result.configureCell(_club)
        return result
    }

    private func cellForPartyAtIndexPath(indexPath: NSIndexPath) -> ClubPartyTableViewCell
    {
        var result: ClubPartyTableViewCell!
        if let cell = tableView.dequeueReusableCellWithIdentifier(Cell_Identifier_ClubPartyCell) as? ClubPartyTableViewCell {
            result = cell
        }
        else {
            result = ClubPartyTableViewCell()
        }
        result.configureCell(_club.parties![indexPath.row])
        return result
    }

}