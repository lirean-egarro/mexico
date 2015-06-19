//
//  SignUp3ViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-12.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class SignUp3ViewController: UIViewController {
    
    @IBOutlet weak var yourField: TextBox!
    @IBOutlet weak var motherField: TextBox!
    @IBOutlet weak var fatherField: TextBox!
    @IBOutlet weak var addButton:UIButton!
    
    @IBOutlet private weak var otherButtons:UIScrollView!
    
    var otherFields:[TextBox]
    private var currentMax:Int
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createNewField() {
        let incY:CGFloat = fatherField.frame.size.height + 30.0
        let newY:CGFloat = 20.0 + CGFloat(incY*CGFloat(otherFields.count))
        let newRect = CGRectMake(0.0, newY, fatherField.frame.size.width, fatherField.frame.size.height)
        
        var newPick = TextBox(frame: newRect, title: "ADDITIONAL LANGUAGE \(otherFields.count + 1)", placeholder: "Enter text here", isSecured: false)
        newPick.tag = (otherFields.count + 1) * 10 + 30
        otherFields.append(newPick)
        self.otherButtons.addSubview(newPick)
        
        self.otherButtons.contentSize = CGSizeMake(self.otherButtons.frame.size.width, newY + 2*incY)
        if self.otherButtons.contentSize.height > self.otherButtons.frame.size.height {
            var bottomOffset = CGPointMake(0, self.otherButtons.contentSize.height - self.otherButtons.bounds.size.height - incY);
            self.otherButtons.setContentOffset(bottomOffset, animated: true)
        }
        
    }
}
