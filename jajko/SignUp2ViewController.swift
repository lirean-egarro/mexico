//
//  SignUp2ViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-12.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class SignUp2ViewController: UIViewController, SegmentsDelegate, JSONReceivable {
    
    var submissionJSON:[String:AnyObject]!
    
    @IBOutlet weak var dexteritySegment:Segments!
    @IBOutlet weak var visualSegment:Segments!
    @IBOutlet weak var hearingSegment:Segments!
    @IBOutlet weak var learningSegment:Segments!
    @IBOutlet weak var neuroSegment:Segments!

    @IBOutlet weak var visualField: TextBox!
    @IBOutlet weak var hearingField: TextBox!
    @IBOutlet weak var learningField: TextBox!
    @IBOutlet weak var neuroField: TextBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dexteritySegment.components = ["Right handed","Left Handed"]
        visualSegment.components = ["No","Yes"]
        hearingSegment.components = ["No","Yes"]
        learningSegment.components = ["No","Yes"]
        neuroSegment.components = ["No","Yes"]
        
        dexteritySegment.delegate = self;
        visualSegment.delegate = self;
        hearingSegment.delegate = self;
        learningSegment.delegate = self;
        neuroSegment.delegate = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        visualField.setUpView()
        hearingField.setUpView()
        learningField.setUpView()
        neuroField.setUpView()
    }
    
// MARK: SegmentsDelegate Methods
    func didUpdate(control: Segments, toValue newValue:String?) {
        if newValue != nil {
            var tag = control.tag
            var state = newValue!.lowercaseString

            var hide = true
            if state == "yes" {
                hide = false
            }
            
            switch tag {
                case 20:
                    visualField.hidden = hide
                case 30:
                    hearingField.hidden = hide
                case 40:
                    learningField.hidden = hide
                case 50:
                    neuroField.hidden = hide
                default:
                    println("Unknown segmented control tag")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "signup2-3") {
            //Pass data to next view
            var biology = [String:AnyObject]()
            biology["dexterity"] = dexteritySegment.selection!
            
            biology["visualImpairments"] = "no"
            if visualSegment.selection!.lowercaseString == "yes" {
                biology["visualImpairments"] = visualField.text ?? ""
            }
            biology["hearingImpairments"] = "no"
            if hearingSegment.selection!.lowercaseString == "yes" {
                biology["hearingImpairments"] = hearingField.text ?? ""
            }
            biology["learningImpairments"] = "no"
            if learningSegment.selection!.lowercaseString == "yes" {
                biology["learningImpairments"] = learningField.text ?? ""
            }
            biology["neurologicalImpairments"] = "no"
            if neuroSegment.selection!.lowercaseString == "yes" {
                biology["neurologicalImpairments"] = neuroField.text ?? ""
            }
            submissionJSON["biologicalInfo"] = biology
            (segue.destinationViewController as! JSONReceivable).submissionJSON = submissionJSON
        }
    }
}
