//
//  CalendarDay.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-29.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

let CALENDAR_FONT_SIZE:CGFloat = 14.0
let CALENDAR_DOT_SIZE:CGFloat = 6.0

protocol CalendarDayDelegate : NSObjectProtocol {
    func calandarDayDidTurnOn(day:Int?)
}

class CalendarDay: UIView {
    var mainLabel:UILabel!
    var hasInfo:Bool
    weak var delegate:CalendarDayDelegate?
    var isOn:Bool {
        willSet {
            self.setNeedsDisplay()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Calendar day must be instantiated from code.")
    }
    
    override init(frame: CGRect) {
        hasInfo = false
        isOn = false
        super.init(frame: frame)
    }
    
    convenience init(frame:CGRect, title: String?, hasInfo:Bool, isSelectable:Bool) {
        self.init(frame: frame)
        
        var labelHeight = CALENDAR_FONT_SIZE + 3.0
        mainLabel = UILabel(frame: CGRectMake(0.0, (frame.size.height - labelHeight)/2.0 - CALENDAR_DOT_SIZE, frame.size.width
            , labelHeight))
        mainLabel.textColor = UIColor.whiteColor()
        mainLabel.font = ControlsConfig.textFontOfSize(CALENDAR_FONT_SIZE)
        mainLabel.textAlignment = .Center
        mainLabel.text = title
        
        self.hasInfo = hasInfo

        //Detect the tap on the view to trigger the check/uncheck events:
        if isSelectable {
            let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
            self.addGestureRecognizer(recognizer)
        }
        
        self.backgroundColor = UIColor.clearColor()
        self.contentMode = UIViewContentMode.Redraw
    }
    
    override func layoutSubviews() {
        self.addSubview(mainLabel)
    }
    
    override func drawRect(rect: CGRect) {        
        if isOn {
            UIColor.whiteColor().setFill();
            CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
            mainLabel.textColor = UIColor.darkGrayColor()
            ControlsConfig.generalGreenColor().set()
        } else {
            UIColor.clearColor().setFill();
            CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
            mainLabel.textColor = UIColor.whiteColor()
            UIColor.whiteColor().set()
        }
        
        if hasInfo {
            var circleRect = CGRectMake((self.frame.size.width-CALENDAR_DOT_SIZE)/2.0,(self.frame.size.height-CALENDAR_DOT_SIZE)/2.0 + CALENDAR_DOT_SIZE,CALENDAR_DOT_SIZE,CALENDAR_DOT_SIZE)
            var myBezier = UIBezierPath(ovalInRect:circleRect)
            myBezier.fill()
        }
    }
    
// MARK: Utility Methods
    func handleTap(recognizer: UITapGestureRecognizer) {
        if isOn {
            self.isOn = false
        } else {
            self.isOn = true
            self.delegate?.calandarDayDidTurnOn(self.mainLabel.text?.toInt())
        }
    }
}
