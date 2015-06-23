//
//  TermsViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-21.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {
    
    @IBOutlet weak var web: UIWebView!
    @IBOutlet weak var agree: SimpleCheckbox!

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
                var options:NSDictionary = [
                    "message" : "You must agree to the Terms and Conditions in order to continue",
                    "yes" : "Okay"
                ]
                PromptManager.sharedInstance.displayAlert(options)
            }
        }
        return false
    }
}