//
//  ExperienceNavigationController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-26.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class ExperienceNavigationController: UINavigationController, ExperienceReceiver {
    
    var experience:Experience!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        (self.viewControllers![0] as! ExperienceReceiver).experience = experience
    }
}

