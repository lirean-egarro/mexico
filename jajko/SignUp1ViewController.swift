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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "signup1-2") {
            //Pass data to next view
            var personalInfo = [String:AnyObject]()
            personalInfo["age"] = ageField.text!
            personalInfo["gender"] = genderSegment.selection!
            personalInfo["level"] = polishSegment.selection!
            submissionJSON["personalInfo"] = personalInfo
            (segue.destinationViewController as! JSONReceivable).submissionJSON = submissionJSON
        }
    }
    
}

