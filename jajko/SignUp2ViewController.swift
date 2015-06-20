//
//  SignUp2ViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-12.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class SignUp2ViewController: UIViewController, SegmentsDelegate {
    
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
}
