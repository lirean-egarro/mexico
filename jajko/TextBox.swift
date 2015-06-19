//
//  TextBox.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-16.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

protocol TextBoxDelegate : NSObjectProtocol {
    func didBeginEditing(textBox:TextBox)
    func didEndEditing(textBox:TextBox)
}

class TextBox : UIView, UITextFieldDelegate {
    
    weak var delegate:TextBoxDelegate?

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
        titleLabel = UILabel()
        textField = UITextField()
        _line = UIImageView()
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame:CGRect, title: String?, placeholder: String?, isSecured:Bool) {
        self.init(frame: frame)
        self.titleLabel = UILabel()
        self.textField = UITextField()
        self._line = UIImageView()
        self.title = title
        self.placeholder = placeholder
        self.secure = isSecured
    }
    
    func setUpView() {
        titleLabel.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 20.0)
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.font = ControlsConfig.titleFont()
        
        textField.frame = CGRectMake(0.0, 25.0, self.frame.size.width, 30.0)
        textField.borderStyle = .None
        textField.delegate = self
        
        _line.frame = CGRectMake(0.0, 56.0, self.frame.size.width, 2.0)
        _line.contentMode = UIViewContentMode.ScaleToFill
        _line.image = UIImage(named: "LineFiller")

        self.addSubview(titleLabel)
        self.addSubview(textField)
        self.addSubview(_line)
    }
    
// MARK: UITextFieldDelegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate?.didBeginEditing(self)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.text = textField.text
        self.delegate?.didEndEditing(self)
    }
        
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
