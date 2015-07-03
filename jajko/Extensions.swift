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

prefix func ~(rhs: MinimalPair) -> MinimalPair {
    return MinimalPair(uid:1000-rhs.uid, mpw: rhs.mpw, ipa1: rhs.ipa2, ipa2: rhs.ipa1, type: rhs.type, contrastIndex: rhs.contrastIdx, order:MPWOrder(rawValue:(rhs.order.rawValue+1)%2)!)
}

//Strong comparison used for Hashable, and Equatable.
//For example, mpw's "koście - koszcie" and "koszcie - koście" are different
func == (lhs: MinimalPair, rhs: MinimalPair) -> Bool {
    
    
    return lhs.uid == rhs.uid
}

//Weak comparison.
//For example, mpw's "koście - koszcie" and "koszcie - koście" are the same
func === (lhs: MinimalPair, rhs: MinimalPair) -> Bool {
    return (lhs.ipa1 == rhs.ipa1 && lhs.ipa2 == rhs.ipa2) || (lhs.ipa1 == rhs.ipa2 && lhs.ipa2 == rhs.ipa1)
}


func > (lhs:ExperienceProgress,rhs:ExperienceProgress) -> Bool {
    var lhsIdx = 0
    for ; lhsIdx < ExperienceProgress.allProgressPoints.count ; lhsIdx++ {
        if lhs == ExperienceProgress.allProgressPoints[lhsIdx] {
            break
        }
    }
    
    var rhsIdx = 0
    for ; rhsIdx < ExperienceProgress.allProgressPoints.count ; rhsIdx++ {
        if rhs == ExperienceProgress.allProgressPoints[rhsIdx] {
            break
        }
    }
    
    return lhsIdx > rhsIdx
}

func > (lhs:Experience,rhs:Experience) -> Bool {
    if lhs.progress == nil {
        return false
    }
    
    if rhs.progress == nil {
        return true
    }
    
    return lhs.progress! > rhs.progress!
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
    subscript (i: Int) -> String {
        return String(self[advance(self.startIndex, i)])
    }
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}

extension NSDate {
    func isSameDayAs(date:NSDate) -> Bool {
        var resp = false
        let calendar = NSCalendar.currentCalendar()
        let thisComponents = calendar.components(.DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit, fromDate: self)
        let thatComponents = calendar.components(.DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit, fromDate: date)
        
        if thisComponents.day == thatComponents.day &&
           thisComponents.month == thatComponents.month &&
           thisComponents.year == thatComponents.year {
            return true
        }
        
        return resp
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

