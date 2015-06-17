//
//  LoginViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-11.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: TextBox!
    @IBOutlet weak var passwordField: TextBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

