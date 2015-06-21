//
//  SimpleCheckbox.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-21.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

@IBDesignable
class SimpleCheckbox : UIButton {
    let DESIRED_LINE_THICKNESS:CGFloat = 2.0
    
    private var circleShape: CAShapeLayer?
    private var checkShape: CAShapeLayer?
    
    var isChecked:Bool {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        isChecked = false
        super.init(coder: aDecoder)
        self.addTarget(self, action: "onTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    override init(frame: CGRect) {
        isChecked = false
        super.init(frame: frame);
        self.addTarget(self, action: "onTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside);
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        var circleColor: UIColor?
        var checkColor: UIColor?
        var fillColor:UIColor?

        if self.isChecked {
            circleColor  = ControlsConfig.generalGreenColor()
            checkColor = UIColor.whiteColor()
            fillColor = ControlsConfig.generalGreenColor()
        } else {
            circleColor = UIColor.lightGrayColor()
            checkColor = UIColor.clearColor()
            fillColor = UIColor.clearColor()
        }
        
        if self.circleShape != nil {
            self.circleShape!.removeFromSuperlayer()
        }
        
        if self.checkShape != nil {
            self.checkShape!.removeFromSuperlayer()
        }
        //Subframes:
        let ovalFrame = CGRectMake(DESIRED_LINE_THICKNESS, DESIRED_LINE_THICKNESS, CGRectGetWidth(self.frame) - 2*DESIRED_LINE_THICKNESS, CGRectGetHeight(self.frame) - 2*DESIRED_LINE_THICKNESS)
        
        self.circleShape = CAShapeLayer()
        var path = UIBezierPath(ovalInRect: ovalFrame)
        self.circleShape!.path = path.CGPath
        self.circleShape!.lineWidth = DESIRED_LINE_THICKNESS
        self.circleShape!.strokeColor = circleColor!.CGColor
        self.circleShape!.fillColor = fillColor!.CGColor
        self.circleShape!.frame = CGRectMake(0.0,0.0,self.frame.size.width,self.frame.size.height)
        self.circleShape!.masksToBounds = true
        
        self.layer.addSublayer(self.circleShape!)
        
        self.checkShape = CAShapeLayer()
        path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGRectGetMinX(ovalFrame) + 0.27083 * CGRectGetWidth(ovalFrame), CGRectGetMinY(ovalFrame) + 0.54167 * CGRectGetHeight(ovalFrame)))
        path.addLineToPoint(CGPointMake(CGRectGetMinX(ovalFrame) + 0.41667 * CGRectGetWidth(ovalFrame), CGRectGetMinY(ovalFrame) + 0.68750 * CGRectGetHeight(ovalFrame)))
        path.addLineToPoint(CGPointMake(CGRectGetMinX(ovalFrame) + 0.75000 * CGRectGetWidth(ovalFrame), CGRectGetMinY(ovalFrame) + 0.35417 * CGRectGetHeight(ovalFrame)))
        path.lineCapStyle = kCGLineCapSquare
        
        self.checkShape!.path = path.CGPath
        self.checkShape!.lineWidth = DESIRED_LINE_THICKNESS
        self.checkShape!.strokeColor = checkColor!.CGColor
        self.checkShape!.fillColor = UIColor.clearColor().CGColor
        self.checkShape!.frame = CGRectMake(0.0,0.0,self.frame.size.width,self.frame.size.height)
        self.checkShape!.masksToBounds = true
        
        self.layer.addSublayer(self.checkShape!)
        
    }
    
    func onTouchUpInside(sender: UIButton) {
        self.isChecked = !self.isChecked;
    }
}