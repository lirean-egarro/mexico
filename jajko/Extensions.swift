//
//  Extensions.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-17.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import Foundation

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
