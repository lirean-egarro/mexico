//
//  InputPopoverVC.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-20.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class InputPopoverVC: UIViewController {
    
    var delegate:InputPopoverDelegate?
    
    private var selectedValue: String! {
        get {
            return self._pickerRows[_picker.selectedRowInComponent(0)]
        }
    }
    
    private var _picker:UIPickerView!
    private var _pickerRows:[String]!
    var startValue: String!
    
    convenience init(value: String?, options: [String], andView picker: UIPickerView) {
        self.init()
        _picker = picker
        _pickerRows = options
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
        
        var buttonsBar = UIToolbar(frame: CGRectMake(0.0, 0.0, 0.0, _picker.frame.origin.y))
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
        
        self.view.frame = CGRectMake(0.0, 0.0, _picker.frame.size.width, _picker.frame.size.height + _picker.frame.origin.y)
        
        //Call this after this view's frame has been set to readjust the width of the button bar:
        buttonsBar.sizeToFit()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: Utility Methods
    func rowForStartValue(aValue:String) -> Int {
        for var i = 0 ; i < _pickerRows.count ; i++ {
            if _pickerRows[i] == aValue {
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
}
