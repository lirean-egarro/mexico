//
//  Segments.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-16.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

//
//  TextBox.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-16.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

protocol SegmentsDelegate : NSObjectProtocol {
    func didUpdate(control:Segments, toValue newValue:String?)
}

class Segments : UIView {
    
    weak var delegate:SegmentsDelegate? = nil
    var titleLabel:UILabel!
    @IBInspectable var title:String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    
    private var _segmentedField:UISegmentedControl!
    private var _components:[String]?
    var components:[String]? {
        get {
            return _components
        }
        set {
            _components = newValue
            self._segmentedField.removeAllSegments()
            if newValue != nil {
                for var i = 0 ; i < newValue!.count; i++ {
                    self._segmentedField.insertSegmentWithTitle(_components![i], atIndex: i, animated: false);
                }
                self._segmentedField.resizeSegmentsToFitTitles()
            }
            self.setNeedsDisplay()
        }
    }
    
    var selection:String? {
        get {
            if _components != nil {
                return _components![_segmentedField.selectedSegmentIndex]
            }
            return nil
        }
        set {
            var found = false
            for var i = 0 ; i < self._segmentedField.numberOfSegments; i++ {
                if self._segmentedField.titleForSegmentAtIndex(i) == newValue {
                    self._segmentedField.selectedSegmentIndex = i
                    found = true
                    break
                }
            }
            if !found {
                println("Selection of segments failed: No such selection \(newValue)")
            }
            
            valueChanged()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        _segmentedField = UISegmentedControl(frame: CGRectZero)
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override init(frame: CGRect) {
        _segmentedField = UISegmentedControl(frame: CGRectZero)
        super.init(frame: frame)
    }
    
    convenience init(frame:CGRect, title: String?, options:[String]) {
        self.init(frame: frame)
        setUpView()
        self.title = title
        components = options
    }
    
    func setUpView() {
        titleLabel = UILabel(frame: CGRectMake(0.0, 0.0, self.frame.size.width, 20.0))
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.font = ControlsConfig.titleFont()
        
        _segmentedField = UISegmentedControl(frame:CGRectMake(0.0, 25.0, self.frame.size.width, 30.0))
        _segmentedField.tintColor = ControlsConfig.generalGreenColor()
        _segmentedField.tag = 10
        _segmentedField.addTarget(self, action: "valueChanged", forControlEvents: UIControlEvents.ValueChanged)
        
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        
        self.title = ""
    }
    
    override func drawRect(rect: CGRect) {
        self.addSubview(titleLabel)
        self.addSubview(_segmentedField)
    }
    
    func valueChanged() {
        self.delegate?.didUpdate(self, toValue: self.selection)
    }
}

