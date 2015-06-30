//
//  SignUp3ViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-12.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class SignUp3ViewController: UIViewController, InputDelegate, JSONReceivable {
    
    var submissionJSON:[String:AnyObject]!
    
    @IBOutlet weak var yourField: TextBox!
    @IBOutlet weak var motherField: TextBox!
    @IBOutlet weak var fatherField: TextBox!
    @IBOutlet weak var addButton:UIButton!
    
    @IBOutlet private weak var otherButtons:UIScrollView!
    @IBOutlet private var bottomConstraint:NSLayoutConstraint!
    
    var otherFields:[TextBox]
    private var currentMax:Int
    private var originalConstraintValue:CGFloat?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        currentMax = 0
        otherFields = Array<TextBox>()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        currentMax = 0
        otherFields = Array<TextBox>()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        originalConstraintValue = bottomConstraint.constant
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        yourField.setUpView()
        motherField.setUpView()
        fatherField.setUpView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createNewField() {
        let incY:CGFloat = fatherField.frame.size.height + 30.0
        let newY:CGFloat = 20.0 + CGFloat(incY*CGFloat(otherFields.count))
        let newRect = CGRectMake(0.0, newY, fatherField.frame.size.width, fatherField.frame.size.height)
        
        
        var newPick = TextBox(frame: newRect, type:.Language, title: "ADDITIONAL LANGUAGE \(otherFields.count + 1)", placeholder: "Enter text here", isSecured: false)
        newPick.tag = (otherFields.count + 1) * 10 + 30
        otherFields.append(newPick)
        self.otherButtons.addSubview(newPick)
        newPick.setUpView()
        newPick.delegate = self

        self.otherButtons.contentSize = CGSizeMake(self.otherButtons.frame.size.width, newY + incY)
        if self.otherButtons.contentSize.height > self.otherButtons.frame.size.height {
            var bottomOffset = CGPointMake(0, self.otherButtons.contentSize.height - self.otherButtons.bounds.size.height);
            self.otherButtons.setContentOffset(bottomOffset, animated: true)
        }
        
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (identifier == "signup3-4") {
            if let y = yourField.text,
                let m = motherField.text,
                let f = fatherField.text {
                    var languageInfo = [String:AnyObject]()
                    languageInfo["self"] = y
                    languageInfo["mother"] = m
                    languageInfo["father"] = f
                    
                    if otherFields.count > 0 {
                        var otherLanguages = [String]()
                        for var i = 0 ; i < otherFields.count ; i++ {
                            if let t = otherFields[i].text {
                                otherLanguages.append(t)
                            }
                        }
                        languageInfo["other"] = otherLanguages
                    }
                    
                    submissionJSON["languageInfo"] = languageInfo
                    return true
            } else {
                var options:NSDictionary = [
                    "message" : "Please fill out the three first required fields before continuing",
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
        if (segue.identifier == "signup3-4") {
            (segue.destinationViewController as! JSONReceivable).submissionJSON = submissionJSON
        }
    }
    
// MARK: Helper methods
    func animateScrollView(up:Bool) {
        let movement:CGFloat = 140.0
        let movementDuration = 1.2
        
        UIView.animateWithDuration(movementDuration) {
            if up {
                self.bottomConstraint.constant = self.originalConstraintValue! + movement;
            } else {
                self.bottomConstraint.constant = self.originalConstraintValue!;
            }
        }
    }
    
// MARK: InputDelegate methods
    func didBeginEditing(obj: Taggable) {
        animateScrollView(true)
    }
    func didEndEditing(obj: Taggable) {
        animateScrollView(false)
    }
}
