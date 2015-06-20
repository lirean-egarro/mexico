//
//  OtherPlaces.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-20.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

let OTHER_PLACES_VIEW_TAG:Int = 1243
let OTHER_PLACES_NEEDED_HEIGHT:CGFloat = 146.0  //2.0*COMPONENT_HEIGHT + COMPONENT_SEPARATOR_HEIGHT

class OtherPlaces : UIView, InputDelegate, Taggable {
    let COMPONENT_SEPARATOR_HEIGHT:CGFloat = 30.0
    let COMPONENT_HEIGHT:CGFloat = 58.0
    
    weak var delegate:InputDelegate?
    
    private var city:TextBox!
    private var pais:TextBox!
    private var age:TextBox!
    private var months:TextBox!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.create()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.create()
    }
    
    func Tag() -> Int {
        return self.tag
    }
    
    func create() {
        let incY = COMPONENT_HEIGHT + COMPONENT_SEPARATOR_HEIGHT;
        city = TextBox(frame: CGRectMake(0.0,0.0,160.0,COMPONENT_HEIGHT), title: "CITY", placeholder: "City", isSecured: false)
        pais = TextBox(frame: CGRectMake(165.0,0.0,160.0,COMPONENT_HEIGHT), title: "COUNTRY", placeholder: "Country", isSecured: false)
        age = TextBox(frame: CGRectMake(0.0,incY,160.0,COMPONENT_HEIGHT), title: "AGE", placeholder: "Since what age?", isSecured: false)
        months = TextBox(frame: CGRectMake(165.0,incY,160.0,COMPONENT_HEIGHT), title: "MONTHS", placeholder: "For how long?", isSecured: false)
        
        city.delegate = self
        pais.delegate = self
        age.delegate = self
        months.delegate = self
    }
    
    func setUpView() {
        
        city.setUpView()
        city.backgroundColor = self.backgroundColor
        pais.setUpView()
        pais.backgroundColor = self.backgroundColor
        age.setUpView()
        age.backgroundColor = self.backgroundColor
        months.setUpView()
        months.backgroundColor = self.backgroundColor
        
        self.addSubview(city)
        self.addSubview(pais)
        self.addSubview(age)
        self.addSubview(months)
        
        self.setNeedsDisplay()
    }
    
    // MARK: InputDelegate methods
    func didBeginEditing(obj:Taggable) {
        self.delegate?.didBeginEditing(self)
    }
    func didEndEditing(obj:Taggable) {
        self.delegate?.didEndEditing(self)
    }
    
}