//
//  SignUp4ViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-12.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class SignUp4ViewController: UIViewController, SegmentsDelegate, InputDelegate, SurpriseMaker {
    
    @IBOutlet weak var surpriseRevealer:UIView!
    
    @IBOutlet weak var birthField: TextBox!
    @IBOutlet weak var currentField: TextBox!
    @IBOutlet weak var ageField: TextBox!
    @IBOutlet weak var howlongField: TextBox!
    @IBOutlet weak var otherSegment:Segments!

    @IBOutlet weak var addButton:UIButton!
    
    @IBOutlet private weak var otherFields:UIScrollView!
    @IBOutlet private var bottomConstraint:NSLayoutConstraint!
    
    var places:[OtherPlaces]
    private var originalConstraintValue:CGFloat?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        places = Array<OtherPlaces>()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        places = Array<OtherPlaces>()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        otherSegment.components = ["No","Yes"]
        otherSegment.delegate = self;
        
        originalConstraintValue = bottomConstraint.constant
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        birthField.setUpView()
        currentField.setUpView()
        ageField.setUpView()
        howlongField.setUpView()
    }
    
    // MARK: SegmentsDelegate Methods
    func didUpdate(control: Segments, toValue newValue:String?) {
        if newValue != nil {
            var state = newValue!.lowercaseString
            
            var hide = true
            if state == "yes" {
                hide = false
            }
            
            if hide {
                self.addButton.hidden = hide
                for tmp in self.otherFields.subviews {
                    tmp.removeFromSuperview()
                }
                self.otherFields.contentSize = CGSizeMake(0.0,0.0)
                places.removeAll(keepCapacity: false)
            } else {
                //Show
                self.addButton.hidden = hide
            }
        }
    }

    @IBAction func createNewPlace() {
        let incY:CGFloat = OTHER_PLACES_NEEDED_HEIGHT + 30.0
        let newY:CGFloat = CGFloat(incY*CGFloat(places.count))
        let newRect = CGRectMake(0.0, newY, self.otherFields.frame.size.width, OTHER_PLACES_NEEDED_HEIGHT)
        
        var newPlace = OtherPlaces(frame: newRect)
        newPlace.tag = OTHER_PLACES_VIEW_TAG
        places.append(newPlace)
        self.otherFields.addSubview(newPlace)
        newPlace.backgroundColor = UIColor(white: 0.99, alpha: 1.0)
        newPlace.setUpView()
        newPlace.delegate = self
        
        self.otherFields.contentSize = CGSizeMake(self.otherFields.frame.size.width, newY + incY)
        if self.otherFields.contentSize.height > self.otherFields.frame.size.height {
            var bottomOffset = CGPointMake(0, self.otherFields.contentSize.height - self.otherFields.bounds.size.height);
            self.otherFields.setContentOffset(bottomOffset, animated: true)
        }
        
    }
    // MARK: Helper methods
    func animateScrollView(up:Bool) {
        let movement:CGFloat = 150.0
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
