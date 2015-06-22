//
//  TextBox.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-16.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit


let JKONeedsToPresentPicker: String! = "JKONeedsToPresentPickerNotification"

class TextBox : UIView, UITextFieldDelegate, UIPopoverControllerDelegate, Taggable, InputPopoverDelegate {
    
    weak var delegate:InputDelegate?

    var titleLabel:UILabel!
    var textField:UITextField!
    
    private var _line:UIImageView!
    private var _popover: UIPopoverController?
    
    func Tag() -> Int {
        return self.tag
    }
    
    var type:InputType!
    @IBInspectable var inputType:Int {
        get {
            if type != nil {
                return type.rawValue
            }
            return InputType.Text.rawValue
        }
        set {
            type = InputType(rawValue: newValue)
        }
    }
    
    @IBInspectable var secure:Bool = false {
        didSet {
            self.textField.secureTextEntry = secure
        }
    }
    
    @IBInspectable var title:String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    @IBInspectable var placeholder:String? {
        get {
            return self.textField.placeholder
        }
        set {
            self.textField.placeholder = newValue
        }
    }
    
    var text:String? {
        get {
            if self.textField.text == "" {
                return nil
            }
            return self.textField.text
        }
        set {
            self.textField.text = newValue
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        titleLabel = UILabel()
        textField = UITextField()
        _line = UIImageView()
        _popover = nil
        type = .Text
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame:CGRect, type:InputType, title: String?, placeholder: String?, isSecured:Bool) {
        self.init(frame: frame)
        self.type = type
        self.titleLabel = UILabel()
        self.textField = UITextField()
        self._line = UIImageView()
        self._popover = nil
        self.title = title
        self.placeholder = placeholder
        self.secure = isSecured
    }
        
    func setUpView() {
        textField.frame = CGRectMake(0.0, 25.0, self.frame.size.width, 30.0)
        textField.borderStyle = .None
        
        switch type! {
        case .Text:
            textField.delegate = self
        default:
            textField!.userInteractionEnabled = false;
            //Detect the tap on the view to bring up the popover control:
            let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
            self.addGestureRecognizer(recognizer)
        }
        
        titleLabel.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 20.0)
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.font = ControlsConfig.titleFont()
        
        _line.frame = CGRectMake(0.0, 56.0, self.frame.size.width, 2.0)
        _line.contentMode = UIViewContentMode.ScaleToFill
        _line.image = UIImage(named: "LineFiller")

        self.addSubview(titleLabel)
        self.addSubview(textField)
        self.addSubview(_line)
    }
    
// MARK: Utility Methods
    func handleTap(recognizer: UITapGestureRecognizer) {
        var options = [String]()
        switch type! {
        case .Number:
            for var i = 0 ; i < 240 ; i++ {
                options.append(String(i))
            }
        case .Age:
            for var i = 0 ; i < 80 ; i++ {
                options.append(String(i))
            }
        case .Month:
            for var i = 1 ; i < 12 ; i++ {
                options.append(String(i))
            }
        case .Country:
            options = CountryHelper.allCountries()
        case .Language:
            options = LanguageHelper.allLanguages()
        default:
            println("Handling tap for an unknown InputType \(type)")
        }
        
        var Info = ["currentValue":self.text ?? "", "options":options]
        NSNotificationCenter.defaultCenter().postNotificationName(JKONeedsToPresentPicker, object: self, userInfo:Info as [NSObject : AnyObject])
        
    }
    
    func presentPopover(controller:InputPopoverVC) {
        controller.delegate = self
        
        _popover =  UIPopoverController(contentViewController:controller)
        _popover!.presentPopoverFromRect(self.frame, inView: self.superview!, permittedArrowDirections: UIPopoverArrowDirection.Up | UIPopoverArrowDirection.Down, animated: true)
        _popover!.delegate = self
    }
    
// MARK: UITextFieldDelegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
        if type! == .Text {
            self.delegate?.didBeginEditing(self)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.text = textField.text
        self.delegate?.didEndEditing(self)
    }
        
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

// MARK: InputPopoverDelegate Method
    func InputPopoverDidFinish(value: String?) {
        self.text = value
        
        if _popover != nil {
            _popover!.dismissPopoverAnimated(true)
        }
    }
    
// MARK: UIPopoverControllerDelegate Methods
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
        _popover = nil
    }
}
