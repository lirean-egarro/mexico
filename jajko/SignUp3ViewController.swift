//
//  SignUp3ViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-12.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class SignUp3ViewController: UIViewController, InputDelegate {
    
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
        
        
        var newPick = TextBox(frame: newRect, title: "ADDITIONAL LANGUAGE \(otherFields.count + 1)", placeholder: "Enter text here", isSecured: false)
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
