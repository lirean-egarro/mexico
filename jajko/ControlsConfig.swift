//
//  ControlsConfig.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-17.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

enum InputType: Int {
    case Text     = 0
    case Number   = 1
    case Age      = 2
    case Month    = 3
    case Country  = 4
    case Language = 5
}

class ControlsConfig {
    class func textFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: size)!
    }
    class func titleFont() -> UIFont {
        return textFontOfSize(14.0)
    }
    class func generalGreenColor() -> UIColor {
        return UIColor(red: 0.3137, green: 0.8235, blue: 0.7608, alpha: 1.0)
    }
}

