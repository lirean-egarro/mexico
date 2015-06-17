//
//  SignUp1ViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-11.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class SignUp1ViewController: UIViewController {
    
    @IBOutlet weak var ageField: TextBox!
    @IBOutlet weak var genderSegment:Segments!
    @IBOutlet weak var polishSegment:Segments!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        genderSegment.components = ["Male","Female"]
        polishSegment.components = ["None","Beg","Inter","Adv","Fluent"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

