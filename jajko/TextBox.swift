//
//  TextBox.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-16.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

@IBDesignable
class TextBox : UIView, UITextFieldDelegate {
    
    var titleLabel:UILabel!
    var textField:UITextField!
    private var _line:UIImageView!
    
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
            return self.textField.text
        }
        set {
            self.textField.text = newValue
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame:CGRect, title: String?, isSecured:Bool) {
        self.init(frame: frame)
        setUpView()
        self.title = title
        self.secure = isSecured
    }
    
    func setUpView() {
        titleLabel = UILabel(frame: CGRectMake(0.0, 0.0, self.frame.size.width, 20.0))
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.font = ControlsConfig.titleFont()
        
        textField = UITextField(frame: CGRectMake(0.0, 25.0, self.frame.size.width, 30.0))
        textField.borderStyle = .None
        textField.placeholder = "Enter text here"
        
        _line = UIImageView(frame: CGRectMake(0.0, 56.0, self.frame.size.width, 2.0))
        _line.contentMode = UIViewContentMode.ScaleToFill
        _line.image = UIImage(named: "LineFiller")
        
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        
        self.title = ""
        self.secure = false
    }
    
    override func drawRect(rect: CGRect) {
        self.addSubview(titleLabel)
        self.addSubview(textField)
        self.addSubview(_line)
    }
    
// MARK: UITextFieldDelegate Methods
    func textFieldDidEndEditing(textField: UITextField) {
        self.text = textField.text
    }
        
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
