//
//  SignUp2ViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-12.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class SignUp2ViewController: UIViewController {
    
    @IBOutlet weak var visualField: UITextField!
    @IBOutlet weak var visualLine: UIView!
    
    @IBOutlet weak var hearingField: UITextField!
    @IBOutlet weak var hearingLine: UIView!
    
    @IBOutlet weak var learningField: UITextField!
    @IBOutlet weak var learningLine: UIView!
    
    @IBOutlet weak var neuroField: UITextField!
    @IBOutlet weak var neuroLine: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func displayTextField(sender: AnyObject) {
        var tag = (sender as UIView).tag
        var state = (sender as UISegmentedControl).selectedSegmentIndex
        var hide = true
        if state == 1 {
            hide = false
        }
        
        switch tag {
            case 10:
                visualField.hidden = hide
                visualLine.hidden = hide
            case 20:
                hearingField.hidden = hide
                hearingLine.hidden = hide
            case 30:
                learningField.hidden = hide
                learningLine.hidden = hide
            case 40:
                neuroField.hidden = hide
                neuroLine.hidden = hide
            default:
                println("Unknown segmented control tag")
        }
    }
}
