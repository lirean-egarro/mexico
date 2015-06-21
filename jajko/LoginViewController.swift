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

// MARK: InputDelegate methods
    func didBeginEditing(obj:Taggable) {
        if obj.Tag() == 10 {
            self.containerView.setContentOffset(CGPointMake(0.0, 30.0), animated: true)
        } else {
            self.containerView.setContentOffset(CGPointMake(0.0, 120.0), animated: true)
        }
    }
    func didEndEditing(obj:Taggable) {
        self.containerView.setContentOffset(CGPointMake(0.0, 0.0), animated: true)
    }
}

