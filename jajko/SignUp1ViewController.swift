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
        if (identifier == "startSignup") {
            if  let age = ageField.text,
                let gender = genderSegment.selection,
                let level = polishSegment.selection {

                var personalInfo = [String:AnyObject]()
                personalInfo["age"] = age
                personalInfo["gender"] = gender
                personalInfo["level"] = level
                submissionJSON["personalInfo"] = personalInfo
                    
                return true
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

