//
//  Extensions.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-17.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import Foundation

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