//
//  ClubListTableViewController.swift
//  Tonight
//
//  Created by Marsal on 29/02/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import UIKit
import Firebase

class ClubListTableViewController : UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    // ****************************** //
    // MARK: Properties
    // ****************************** //
    
    private var _clubs: [Club] = [Club]()
    private var _selectedClub: Club!
    
    // *********************************** //
    // MARK: <UIViewController> Lifecycle
    // *********************************** //
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // update selected filter and fetch data from server
        _selectedFilter = _pickerData[0]
        self.fetchDataFromCity(_selectedFilter!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == Segue_ListToDetail) {
            let viewController = segue.destinationViewController as! ClubDetailsTableViewController
            viewController.club = _selectedClub
        }
    }
    
    func updateTitle()
    {
        self.navigationItem.title = "\(_selectedFilter!)"
    }
    
    // *********************************** //
    // MARK: <UITableViewDataSource>
    // *********************************** //
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return _clubs.count
    }
    
    // *********************************** //
    // MARK: <UITableViewDelegate>
    // *********************************** //
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var result: ClubListTableViewCell!
        if let cell = tableView.dequeueReusableCellWithIdentifier(Cell_Identifier_ClubListCell) as? ClubListTableViewCell {
            result = cell
        }
        else {
            result = ClubListTableViewCell()
        }
        result.configureCell(_clubs[indexPath.row])
        return result
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        _selectedClub = _clubs[indexPath.row]
        performSegueWithIdentifier(Segue_ListToDetail, sender: self)
    }
    
    // *********************************** //
    // MARK: Load Data
    // *********************************** //
    
    @IBAction func btnChangeFilterTap(sender: UIBarButtonItem)
    {
        self.showPickerInActionSheet()
    }
    
    private func fetchDataFromCity(city: String)
    {
        // wait until Firebase send data or occurs some event
        FirebaseApp.sharedInstance().fetchClubsWithFilter(city, completionBlock: { clubs in
            
            // update clubs list and refresh table data with new values
            self._clubs = clubs
            self.tableView.reloadData()
            
        }, failBlock: { error in
            Logger.log("Errro fetching data. Error: \(error.localizedDescription)")
            
            // create and configure alert to ask user confirmation to do logout
            let alert = UIAlertController(title: "Tonight!", message: "Error fetching data.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
        
        // finally update title with selected filter
        self.updateTitle()
    }
    
    // *************************************************************** //
    // MARK: Filter Controller
    // *************************************************************** //
    
    private let _pickerData = [Filter_All_Places, Filter_Palhoca, Filter_Santo_Amaro_da_Imperatriz, Filter_Sao_Jose, Filter_Florianopolis]
    private var _selectedFilter: String?
    
    // PickerView inside AlertController
    private func showPickerInActionSheet()
    {
        let title = ""
        let message = "\n\n\n\n\n\n\n\n\n\n"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.modalInPopover = true
        
        // create a frame (placeholder/wrapper) for the picker and then create the picker... so add the picker to alert controller
        let picker: UIPickerView = UIPickerView(frame: CGRectMake(17, 52, 270, 100))
        picker.delegate = self
        picker.dataSource = self
        alert.view.addSubview(picker)
        
        // configure picker position
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            picker.center.x = self.view.center.x
        }
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            alert.popoverPresentationController?.sourceView = self.view
//            alert.popoverPresentationController?.sourceRect = picker.bounds
        }
        
        // set selected filter as selected value in picker view
        picker.selectRow(_pickerData.indexOf(_selectedFilter!)!, inComponent: 0, animated: true)
        
        // create the toolbar view - the view witch will hold our 2 buttons
        let toolView: UIView = UIView(frame: CGRectMake(17, 5, 270, 45))
        
        // add cancel button to alert
        let buttonCancel: UIButton = UIButton(frame: CGRectMake(0, 7, 100, 30))
        buttonCancel.setTitle("Cancel", forState: UIControlState.Normal)
        buttonCancel.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        buttonCancel.addTarget(self, action: "btnCancelTap:", forControlEvents: UIControlEvents.TouchDown);
        toolView.addSubview(buttonCancel)
        
        // add select button to alert
        let buttonSelect: UIButton = UIButton(frame: CGRectMake(170, 7, 100, 30));
        buttonSelect.setTitle("Select", forState: UIControlState.Normal);
        buttonSelect.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal);
        buttonSelect.addTarget(self, action: "btnFilterTap:", forControlEvents: UIControlEvents.TouchDown);
        toolView.addSubview(buttonSelect);
        
        //add the toolbar to the alert controller
        alert.view.addSubview(toolView);
        
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    func btnCancelTap(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func btnFilterTap(sender: UIButton)
    {
        // close ui and refresh data
        self.dismissViewControllerAnimated(true, completion: nil);
        self.fetchDataFromCity(_selectedFilter!)
    }
    
    // *************************************************************** //
    // MARK: <UIPickerViewDataSource>
    // *************************************************************** //
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return _pickerData.count
    }
    
    // *************************************************************** //
    // MARK: <UIPickerViewDelegate>
    // *************************************************************** //

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return _pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        _selectedFilter = _pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        let titleData = _pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
        return myTitle
    }
}