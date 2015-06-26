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

protocol ExperienceReceiver: NSObjectProtocol {
    var experience:Experience! { get set }
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

prefix func ~(rhs: MinimalPair) -> MinimalPair {
    return MinimalPair(mpw: rhs.mpw, ipa1: rhs.ipa2, ipa2: rhs.ipa1, type: rhs.type, contrastIndex: rhs.contrastIdx, order:MPWOrder(rawValue:(rhs.order.rawValue+1)%2)!)
}

//Strong comparison used for Hashable, and Equatable.
//For example, mpw's "koście - koszcie" and "koszcie - koście" are different
func == (lhs: MinimalPair, rhs: MinimalPair) -> Bool {
    return (lhs.ipa1 == rhs.ipa1 && lhs.ipa2 == rhs.ipa2)
}

//Weak comparison.
//For example, mpw's "koście - koszcie" and "koszcie - koście" are the same
func === (lhs: MinimalPair, rhs: MinimalPair) -> Bool {
    return (lhs.ipa1 == rhs.ipa1 && lhs.ipa2 == rhs.ipa2) || (lhs.ipa1 == rhs.ipa2 && lhs.ipa2 == rhs.ipa1)
}

extension Array {
    func shuffled() -> [T] {
        var list = self
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
}

func randomElement<T>(s: Set<T>) -> T {
    let n = Int(arc4random_uniform(UInt32(s.count)))
    for (i, e) in enumerate(s) {
        if i == n { return e }
    }
    fatalError("The above loop must succeed @ randomElement")
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

