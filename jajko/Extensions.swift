//
//  Extensions.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-17.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import Foundation

extension String {
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}