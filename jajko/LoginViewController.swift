//
//  LoginViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-11.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, InputDelegate {

    @IBOutlet weak var usernameField: TextBox!
    @IBOutlet weak var passwordField: TextBox!
    
    @IBOutlet weak var myIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var containerView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameField.setUpView()
        passwordField.setUpView()
    }
        
    @IBAction func login(sender: AnyObject) {
        if doLogin() {
        
        } else {
        
        }
    }
    
    @IBAction func cancelToLoginViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func savePlayerDetail(segue:UIStoryboardSegue) {
        
    }
    
    func doLogin() -> Bool {
        var didLogin = false
        let username = self.usernameField.text
        let password = self.passwordField.text
        
        
        return didLogin
    }

// MARK: Utility methods
    func show(message: String) {
        messageLabel.text = message
        messageLabel.hidden = false
    }
    func hideMessage() {
        messageLabel.text = ""
        messageLabel.hidden = true
    }
    
// MARK: InputDelegate methods
    func didBeginEditing(obj:Taggable) {
        hideMessage()
        if obj.Tag() == 10 {
            self.containerView.setContentOffset(CGPointMake(0.0, 30.0), animated: true)
        } else {
            self.containerView.setContentOffset(CGPointMake(0.0, 120.0), animated: true)
        }
    }
    func didEndEditing(obj:Taggable) {
        self.containerView.setContentOffset(CGPointMake(0.0, 0.0), animated: true)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (identifier == "startSignup") {
            let username = self.usernameField.text
            if username != nil && username != "" // && isValidEmail(username)
            {
                //Check if email is not taken, etc...
            } else {
                show("You must enter a valid email address as username in order to signup!")
                return false
            }
        }

        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "startSignup") {
            // pass data to next view
        }
    }
}

