//
//  NotifyingNavigationController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-20.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

let PREFERRED_PICKER_TOOLBAR_HEIGHT:CGFloat = 30.0
let CONSTANT_PICKER_HEIGHT:CGFloat = 162.0
let MAX_PICKER_WIDTH:CGFloat = 500.0
let MIN_PICKER_WIDTH:CGFloat = 180.0
let FONT_FOR_OPTIONS:UIFont = UIFont.boldSystemFontOfSize(18.0)

class NotifyingNavigationController: UINavigationController, UIPickerViewDataSource, UIPickerViewDelegate {
    let REMOVABLE_SUBVIEW_TAG:Int = 1723
    
    var currentInputSource:TextBox!
    var optionsForPicker:[String]! {
        didSet {
            self.widthForPicker = self.neededWithForPicker()
        }
    }
    
    var widthForPicker:CGFloat!
    var isPresentingPicker:Bool!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        isPresentingPicker = false
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "buildAndPresentPicker:",
            name: JKONeedsToPresentPicker,
            object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func buildAndPresentPicker(notification: NSNotification) {
        optionsForPicker = notification.userInfo!["options"] as! [String]
        currentInputSource = notification.object as! TextBox
        let currentText = notification.userInfo!["currentValue"] as! String
        
        let picker = buildPicker()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            picker.frame = CGRectMake(0.0, PREFERRED_PICKER_TOOLBAR_HEIGHT, widthForPicker, 162.0)
            var inputPickerController = InputPopoverVC(value: currentText, options:optionsForPicker, andView:picker)
            inputPickerController.modalPresentationStyle = .Popover
            inputPickerController.preferredContentSize = CGSizeMake(widthForPicker,picker.frame.size.height + PREFERRED_PICKER_TOOLBAR_HEIGHT)
            
            currentInputSource.presentPopover(inputPickerController)
        } else if !isPresentingPicker {
            
            isPresentingPicker = true
            let parentView = self.topViewController.view
            
            var buttonsBar = createToolBar()
            buttonsBar.frame = CGRectMake(0.0, parentView.bounds.size.height, parentView.bounds.size.width, PREFERRED_PICKER_TOOLBAR_HEIGHT)

            picker.frame = CGRectMake(0.0, parentView.bounds.size.height + PREFERRED_PICKER_TOOLBAR_HEIGHT, parentView.bounds.size.width, CONSTANT_PICKER_HEIGHT)
            
            self.topViewController.view.addSubview(buttonsBar)
            self.topViewController.view.addSubview(picker)
            
            animateTopController(true)
        }
    }

// MARK: Utility Methods Methods
    func createToolBar() -> UIToolbar {
        var buttonsBar = UIToolbar()
        buttonsBar.barStyle = .Default
        buttonsBar.translucent = false
        buttonsBar.tag = self.REMOVABLE_SUBVIEW_TAG
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action:Selector("valueChanged"))
        var clearButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.Bordered, target: self, action:Selector("valueCleared"))
        var flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        var pickerItems = [clearButton,flex,doneButton]
        buttonsBar.setItems(pickerItems, animated: false)
        
        return buttonsBar
    }
    
    func animateTopController(up:Bool) {
        let parentView = self.topViewController.view
        var views = [UIView]()
        for view in parentView.subviews {
            if view.tag == REMOVABLE_SUBVIEW_TAG {
                views.append(view as! UIView)
            }
        }
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveLinear, animations: {
            for view in views {
                var thisFrame = view.frame
                thisFrame.origin.y = thisFrame.origin.y + (up ? -1.0 : 1.0) * (PREFERRED_PICKER_TOOLBAR_HEIGHT + CONSTANT_PICKER_HEIGHT)
                view.frame = thisFrame
            }
        }, completion: { finished in
            if !up {
                for view in parentView.subviews {
                    if view.tag == self.REMOVABLE_SUBVIEW_TAG {
                        view.removeFromSuperview()
                    }
                }
            }
        })
    }

    func valueChanged() {
        isPresentingPicker = false
        animateTopController(false)
        currentInputSource.InputPopoverDidFinish(currentInputSource.text)
    }
    func valueCleared() {
        isPresentingPicker = false
        animateTopController(false)
        currentInputSource.InputPopoverDidFinish(nil)
    }
    
    func buildPicker() -> UIPickerView {
        var aPicker = UIPickerView()
        aPicker.showsSelectionIndicator = true
        aPicker.dataSource = self
        aPicker.delegate = self
        aPicker.tag = self.REMOVABLE_SUBVIEW_TAG
        aPicker.backgroundColor = UIColor.whiteColor()
        
        return aPicker
    }
    
    func neededWithForPicker() -> CGFloat {
        var maxWidth:CGFloat = 0.0
        let attributes = [NSFontAttributeName : FONT_FOR_OPTIONS]
        for string in optionsForPicker! {
            var textSize = (string as NSString).sizeWithAttributes(attributes)
            if textSize.width > maxWidth {
                maxWidth = textSize.width
            }
        }
        
        if maxWidth > MAX_PICKER_WIDTH {
            maxWidth = MAX_PICKER_WIDTH
        } else if maxWidth < MIN_PICKER_WIDTH {
            maxWidth = MIN_PICKER_WIDTH
        }
        
        return maxWidth + 30.0
    }
    
// MARK: UIPickerViewDataSource Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return optionsForPicker.count
    }

// MARK: UIPickerViewDelegate Methods
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentInputSource.text = optionsForPicker[row]
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 206.0
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var resp = UILabel(frame: CGRectMake(0.0, 0.0, widthForPicker, 32.0));
        resp.textAlignment = NSTextAlignment.Center
        resp.backgroundColor = UIColor.clearColor()
        resp.font = FONT_FOR_OPTIONS
        resp.text = optionsForPicker[row]
        
        return resp;
    }
    
}
