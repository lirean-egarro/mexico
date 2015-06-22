//
//  PromptManager.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-21.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

class PromptManager: NSObject, UITextFieldDelegate, UIAlertViewDelegate {
    typealias PromptManagerCompletionClosure = ((response: Bool) -> Void)
    
    private var currentAction:PromptManagerCompletionClosure?
    private var currentAlert:UIAlertController?
    
    class var sharedInstance : PromptManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : PromptManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = PromptManager()
        }
        return Static.instance!
    }
    
    func displayAlert(options: NSDictionary, completion:PromptManagerCompletionClosure? = nil) {
        if let message = nullToNil(options.objectForKey("message")) as? String {
            var y_title = "OK"
            if let yes = nullToNil(options.objectForKey("yes")) as? String {
                y_title = yes
            }

            let no = nullToNil(options.objectForKey("no")) as? String
            
            if objc_getClass("UIAlertController") != nil {
                var alert = UIAlertController(title: "Attention", message: message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: y_title, style: .Default, handler: { action in
                    if completion != nil {
                        completion!(response: true)
                    }
                }))
                if no != nil {
                    alert.addAction(UIAlertAction(title: no!, style: .Default, handler: { action in
                        if completion != nil {
                            completion!(response: false)
                        }
                    }))
                }
                alert.show()
            }
            else {
                currentAction = completion
                var alert:UIAlertView
                if no == nil {
                    alert = UIAlertView(title: "Attention", message: message, delegate: nil, cancelButtonTitle: y_title)
                } else {
                    alert = UIAlertView(title: "Attention", message: message, delegate: nil, cancelButtonTitle: y_title, otherButtonTitles: no!)
                }
                alert.delegate = self
                alert.show()
            }
        } else {
            println("Incoming alert request contains no message")
            completion!(response: false)
        }
    }
    
// MARK: UIAlertViewDelegate Methods
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == alertView.cancelButtonIndex {
            currentAction?(response: true)
        } else {
            currentAction?(response: false)
        }
        
        alertView.dismissWithClickedButtonIndex(buttonIndex, animated: true)
    }
}

