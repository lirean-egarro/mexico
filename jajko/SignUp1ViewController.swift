//
//  SignUp1ViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-11.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class SignUp1ViewController: UIViewController, JSONReceivable {
    
    var submissionJSON:[String:AnyObject]!
    
    @IBOutlet weak var ageField: TextBox!
    @IBOutlet weak var genderSegment:Segments!
    @IBOutlet weak var polishSegment:Segments!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        genderSegment.components = ["Male","Female"]
        polishSegment.components = ["None","Beg","Inter","Adv","Fluent"]        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ageField.setUpView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (identifier == "signup1-2") {
            if  let age = ageField.text,
                let gender = genderSegment.selection,
                let level = polishSegment.selection {

                var personalInfo = [String:AnyObject]()
                personalInfo["age"] = age
                personalInfo["gender"] = gender
                personalInfo["level"] = level
                submissionJSON["personalInfo"] = personalInfo
                    
                return true
            } else {
                var options:NSDictionary = [
                    "message" : "Please fill out the entire page before continuing",
                    "yes" : "Okay"
                ]
                PromptManager.sharedInstance.displayAlert(options)
            }
        } else if (identifier == "cancelUnwind") {
            var options:NSDictionary = [
                "message" : "If you cancel this form, you will loose all the information you've input so far. Are you sure you want to continue?",
                "yes" : "Yes",
                "no" : "No"
            ]
            PromptManager.sharedInstance.displayAlert(options) { (resp) in
                if resp {
                    self.performSegueWithIdentifier("cancelUnwind", sender: nil)
                }
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "signup1-2") {
            (segue.destinationViewController as! JSONReceivable).submissionJSON = submissionJSON
        } 
    }
    
}

