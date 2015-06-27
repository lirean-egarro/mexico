//
//  LoginViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-11.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, InputDelegate, NavigationPusher {
    let MINIMUM_PASSWORD_LENGTH:Int = 5
    
    @IBOutlet weak var usernameField: TextBox!
    @IBOutlet weak var passwordField: TextBox!
    
    @IBOutlet weak var myIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var containerView: UIScrollView!
    
    weak var nextController:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        if let previousUser = NSUserDefaults.standardUserDefaults().objectForKey("lastUser") as? String {
            usernameField.text = previousUser
        }
        
        Corpus()
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

#if DEBUG
    @IBAction func login(sender: AnyObject) {
        Webservice.sharedInstance.currentUser = self.usernameField.text
        self.performSegueWithIdentifier("goToDashboard", sender: nil)
    }
#else
    @IBAction func login(sender: AnyObject) {
        if let username = self.usernameField.text,
            let password = self.passwordField.text {
                if isValid(username) {
                    myIndicator.startAnimating()
                    Webservice.sharedInstance.login(username, password: password) { (resp) in
                        dispatch_async(dispatch_get_main_queue()) {
                            self.myIndicator.stopAnimating()
                            if resp != nil {
                                if resp! {
                                    self.performSegueWithIdentifier("goToDashboard", sender: nil)
                                } else {
                                    self.show("Wrong username and password or site is unavailable")
                                }
                            } else {
                                //User exists but hasn't yet completed the questionnaire. 
                                self.performSegueWithIdentifier("startSignup", sender: nil)
                            }
                        }
                    }
                } else {
                    show("Your username is the email you signed up with!")
                }
        } else {
            show("Please enter your user name and password")
        }
    }
#endif
    
    @IBAction func logoutIntoLoginVC(segue:UIStoryboardSegue) {
        println("Logging out!")
        Webservice.sharedInstance.logout()
        self.passwordField.text = ""
        nextController = self
    }
    
    @IBAction func cancelToLoginViewController(segue:UIStoryboardSegue) {
        println("Canceling into Login Page")
        nextController = self
    }
    
    @IBAction func savePlayerDetail(segue:UIStoryboardSegue) {
        nextController = self
        let submissionJSON = (segue.sourceViewController as! JSONReceivable).submissionJSON
        myIndicator.startAnimating()
        Webservice.sharedInstance.questionnaire(submissionJSON) { (resp) in
            dispatch_async(dispatch_get_main_queue()) {
                self.myIndicator.stopAnimating()
                if resp {
                    self.performSegueWithIdentifier("goToDashboard", sender: nil)
                } else {
                    var options:NSDictionary = [
                        "message" : "There was a problem saving your answers. Verify your internet connection and try again. If you decide to cancel now, you will loose all the information you've input so far",
                        "yes" : "Cancel",
                        "no" : "Try again"
                    ]
                    PromptManager.sharedInstance.displayAlert(options) { (resp) in
                        if !resp {
                            self.savePlayerDetail(segue)
                        }
                    }
                }
            }
        }
    }
    
    func doLogin() -> Bool {
        var didLogin = false
        let username = self.usernameField.text
        let password = self.passwordField.text
        
        return didLogin
    }

// MARK: Utility methods
    func isValid(email:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
    }
    
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
    
    @IBAction func SignUp() {
        if let username = self.usernameField.text,
            let password = self.passwordField.text {
                if isValid(username) {
                    if count(password) >= MINIMUM_PASSWORD_LENGTH {
                        //Check if username is available:
                        myIndicator.startAnimating()
                        Webservice.sharedInstance.create(username, password: password) { (resp) in
                            dispatch_async(dispatch_get_main_queue()) {
                                self.myIndicator.stopAnimating()
                                if resp {
                                    self.performSegueWithIdentifier("startSignup", sender: nil)
                                } else {
                                    self.show("This username is already taken or site is unavailable. Please try again")
                                }
                            }
                        }
                    } else {
                        show("Your password must contain at least \(MINIMUM_PASSWORD_LENGTH) characters")
                    }
                } else {
                    show("You must enter a valid email address")
                }
        } else {
            show("Both email and password must be present in order to signup")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "startSignup") {
            nextController = segue.destinationViewController as? UIViewController
        }
    }
}

