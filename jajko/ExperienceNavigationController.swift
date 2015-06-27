//
//  ExperienceNavigationController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-26.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class ExperienceNavigationController: UINavigationController {
    
    var experience:Experience!
    var session:Session!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("Experience Navigation Controller must load from storyboard!")
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        
        //Create the session!
        if let progress = experience.progress {
            switch progress {
            case .Start:
                session = Session(type: .Pretest)
            case .Test:
                session = Session(type: .Posttest)
            case .End:
                fatalError("Shouldn't try to start session after all sessions are done")
            default:
                session = Session(type: .Training)
            }
        }
    }
}

