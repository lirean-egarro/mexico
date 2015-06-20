//
//  InputPopoverVC.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-20.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class InputPopoverVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let HEIGHT_FOR_CONTROL:CGFloat = 206.0
    let PREFERRED_TOOLBAR_HEIGHT:CGFloat = 30.0
    let MAX_WIDTH_FOR_CONTROL:CGFloat = 500.0
    let MIN_WIDTH_FOR_CONTROL:CGFloat = 180.0
    let FONT_FOR_OPTIONS:UIFont = UIFont.boldSystemFontOfSize(18.0)
    
    var delegate:InputPopoverDelegate?
    
    var neededHeight : CGFloat {
        get {
            return HEIGHT_FOR_CONTROL
        }
    }
    
    lazy var neededWidth : CGFloat = {
        var maxWidth:CGFloat = 0.0
        let attributes = [NSFontAttributeName : self.FONT_FOR_OPTIONS]
        for string in self.strings {
            var textSize = (string as NSString).sizeWithAttributes(attributes)
            if textSize.width > maxWidth {
                maxWidth = textSize.width
            }
        }
        
        if maxWidth > self.MAX_WIDTH_FOR_CONTROL {
            maxWidth = self.MAX_WIDTH_FOR_CONTROL
        } else if maxWidth < self.MIN_WIDTH_FOR_CONTROL {
            maxWidth = self.MIN_WIDTH_FOR_CONTROL
        }
        
        return maxWidth + 30.0
    }()
    
    private var selectedValue: String! {
        get {
            return self.strings[_picker.selectedRowInComponent(0)]
        }
    }
    
    lazy private var _picker : UIPickerView = {
        var buttonsHeight = self.PREFERRED_TOOLBAR_HEIGHT
        for view in self.view.subviews {
            if(view.tag == 1000) {
                buttonsHeight = view.frame.size.height
                break
            }
        }
        
        var aPicker = UIPickerView(frame: CGRectMake(0.0, buttonsHeight, self.neededWidth, 100.0))
        aPicker.showsSelectionIndicator = true
        aPicker.delegate = self
        aPicker.dataSource = self
        aPicker.tag = 2000
        //This call initializes the lazy loaded strings variable, and sets the value for the day-,month-, and year-Component,
        self.strings.count
        
        return aPicker
        }()
    
    var startValue: String!
    var strings:[String]!
    
    convenience init(value: String?, options: [String]) {
        self.init()
        strings = options
        startValue = value ?? ""
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("InputPopoverVC: NSCoding not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var buttonsBar = UIToolbar(frame: CGRectMake(0.0, 0.0, 0.0, PREFERRED_TOOLBAR_HEIGHT))
        buttonsBar.barStyle = .Default
        buttonsBar.translucent = true
        buttonsBar.tag = 1000
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action:Selector("valueChanged"))
        var clearButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.Bordered, target: self, action:Selector("valueCleared"))
        var flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        var pickerItems = [clearButton,flex,doneButton]
        buttonsBar.setItems(pickerItems, animated: false)
        
        self.view.addSubview(buttonsBar)
        
        //This call to _picker initializates all uninitialized variables!
        self.view.addSubview(_picker)
        
        _picker.selectRow(rowForStartValue(startValue), inComponent: 0, animated: false)
        
        self.view.frame = CGRectMake(0.0, 0.0, neededWidth, neededHeight)
        
        //Call this after this view's frame has been set to readjust the width of the button bar:
        buttonsBar.sizeToFit()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: Utility Methods
    func rowForStartValue(aValue:String) -> Int {
        for var i = 0 ; i < strings.count ; i++ {
            if strings[i] == aValue {
                return i
            }
        }
        
        return 0
    }
    
    func valueChanged() {
        if delegate != nil {
            //Figure out the selected date:
            delegate!.InputPopoverDidFinish(self.selectedValue)
        }
    }
    func valueCleared() {
        if delegate != nil {
            delegate!.InputPopoverDidFinish(nil)
        }
    }
    
    // MARK: UIPickerViewDataSource Methods\
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return strings.count
    }
    
    // MARK: UIPickerViewDelegate Methods	
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return HEIGHT_FOR_CONTROL
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var resp = UILabel(frame: CGRectMake(0.0, 0.0, neededWidth, 32.0));
        resp.textAlignment = NSTextAlignment.Center
        resp.backgroundColor = UIColor.clearColor()
        resp.font = FONT_FOR_OPTIONS
        resp.text = strings[row]
        
        return resp;
    }
}
