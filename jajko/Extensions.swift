//
//  Extensions.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-17.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import Foundation

protocol NavigationPusher {
    weak var nextController:UIViewController? { get set }
}

protocol JSONReceivable: NSObjectProtocol {
    var submissionJSON:[String:AnyObject]! { get set }
}

protocol SurpriseMaker: NSObjectProtocol {
    var surpriseRevealer:UIView! { get }
}

protocol InputPopoverDelegate : NSObjectProtocol {
    func InputPopoverDidFinish(value: String?)
}

protocol Taggable : NSObjectProtocol {
    func Tag() -> Int
}

protocol InputDelegate : NSObjectProtocol {
    func didBeginEditing(obj:Taggable)
    func didEndEditing(obj:Taggable)
}

func nullToNil(value : AnyObject?) -> AnyObject? {
    if value is NSNull {
        return nil
    } else {
        return value
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}

extension NSDictionary {
    func toJSONString() -> NSString? {
        var error: NSError?
        if let jsonData = NSJSONSerialization.dataWithJSONObject(self, options:NSJSONWritingOptions.allZeros , error: &error) {
            if error != nil {
                println("An error occured decoding NSDictionary:",error!.localizedDescription)
            } else {
                return NSString(data: jsonData, encoding: NSUTF8StringEncoding)?.stringByReplacingOccurrencesOfString("\\/", withString: "/")
            }
        }
        
        return nil
    }
}

extension UIAlertController {
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(#animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController {
            presentFromController(rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController, let visibleVC = navVC.visibleViewController {
            presentFromController(visibleVC, animated: animated, completion: completion)
        } else if let tabVC = controller as? UITabBarController, let selectedVC = tabVC.selectedViewController {
            presentFromController(selectedVC, animated: animated, completion: completion)
        }  else if let VC = controller as? NavigationPusher,
            let nextVC = VC.nextController {
                nextVC.presentViewController(self, animated: animated, completion: completion)
        } else {
                controller.presentViewController(self, animated: animated, completion: completion)
        }
    }
}

