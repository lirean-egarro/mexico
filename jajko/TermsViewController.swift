//
//  TermsViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-21.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController, JSONReceivable {

    var submissionJSON:[String:AnyObject]!
    
    @IBOutlet weak var web: UIWebView!
    @IBOutlet weak var agree: SimpleCheckbox!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bundleURL = NSBundle.mainBundle().bundleURL
        var docURL = bundleURL.URLByAppendingPathComponent("Consent.pdf")
        web.loadRequest(NSURLRequest(URL: docURL))
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (identifier == "signupT-1") {
            if agree.isChecked {
                    return true
            } else {
                if objc_getClass("UIAlertController") != nil {
                    var alert = UIAlertController(title: "Attention", message: "You must agree to the Terms and Conditions in order to continue", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else {
                    var alert = UIAlertView(title: "Attention", message: "You must agree to the Terms and Conditions in order to continue", delegate: nil, cancelButtonTitle: "Okay")
                    alert.show()
                }
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