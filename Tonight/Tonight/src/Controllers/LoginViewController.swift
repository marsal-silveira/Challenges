//
//  LoginViewController.swift
//  Tonight
//
//  Created by Marsal on 29/02/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController
{
    // *********************************** //
    // MARK: <UIViewController> Lifecycle
    // *********************************** //
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        // try to restore previous session (if has one)
        if (Session.sharedInstance().restorePreviousSession()) {
            self.segueToMain()
        }
    }
 
    // *********************************** //
    // MARK: @IBOutlet
    // *********************************** //

    @IBOutlet weak var edtEmail: UITextField!
    @IBOutlet weak var edtPassword: UITextField!
    
    // *********************************** //
    // MARK: @IBAction
    // *********************************** //
    
    @IBAction func btnLoginTap(sender: UIButton)
    {
        // try do login using email and password
        Session.sharedInstance().doLoginWithEmail(edtEmail.text!, andPassword: edtPassword.text!, withCompletionBlock: { logged, message in
            
            // logged... so segue to next screen
            if (logged) {
                self.segueToMain()
            }
            // not logged... show error and abort operation
            else {
                self.loginErrorAlert("Oops!", message: message)
            }
        })
    }
    
    @IBAction func btnSignUpTap(sender: UIButton)
    {
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction) -> Void in
            
            let nameField = alert.textFields![0]
            let emailField = alert.textFields![1]
            let passwordField = alert.textFields![2]
            
            Session.sharedInstance().doSignUpWithName(nameField.text!, email: emailField.text!, andPassword: passwordField.text!, withCompletionBlock: { logged, message in
                
                // logged... so segue to next screen
                if (logged) {
                    self.segueToMain()
                }
                // not logged... show error and abort operation
                else {
                    self.loginErrorAlert("Oops!", message: message)
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in }
        
        alert.addTextFieldWithConfigurationHandler {
            (textName) -> Void in
            textName.placeholder = "Enter your name"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textEmail) -> Void in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textPassword) -> Void in
            textPassword.secureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnLoginWithFacebookTap(sender: UIButton)
    {
        // try do login using email and password
        Session.sharedInstance().doLoginWithFacebookFromViewController(self, completionBlock: { logged, message in
            
            // logged... so segue to next screen
            if (logged) {
                self.segueToMain()
            }
                // not logged... show error and abort operation
            else {
                self.loginErrorAlert("Oops!", message: message)
            }
        })
    }
    
    // *********************************** //
    // MARK: Utils
    // *********************************** //

    func loginErrorAlert(title: String, message: String)
    {
        // Called upon login error to let the user know login didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func segueToMain()
    {
        self.performSegueWithIdentifier(Segue_LoginToMain, sender: self)
    }
    
}