//
//  GettingReadyVC.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-26.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class SessionMessageVC: UIViewController {
    
    @IBOutlet weak var whiteLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!

    @IBOutlet weak var messageIcon: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var instructions = ""
        var message = ""
        
        var progress = (self.navigationController! as! ExperienceNavigationController).experience.progress!
        
        switch progress {
        case .Start:
            instructions = "This excercise should take you about 30 minutes.\n\n"
            instructions += "You will listen to each audio sample two times. After that you will be presented with two options to choose from. Only one option is correct.\n\n"
            instructions += "Make your choice to move on to the next file."
        
            message = "Ready?"
        case let p where p == .Train1 || p == .Train2 || p == .Train3 || p == .Train4 || p == .Train5 || p == .Train6 || p == .Train7 || p == .Train8:
            instructions = "This excercise should take you about 30 minutes.\n\n"
            instructions += "You will listen to each audio sample two times. After that you will be presented with two options to choose from. Only one option is correct.\n\n"
            instructions += "Make your choice to move on to the next file."

            message = "Ready?"
        case .Test:
            instructions = "This excercise should take you about 30 minutes.\n\n"
            instructions += "You will listen to each audio sample two times. After that you will be presented with two options to choose from. Only one option is correct.\n\n"
            instructions += "Make your choice to move on to the next file."

            message = "Ready?"
        default:
            println("You shouldn't be here...")
        }
        
        self.whiteLabel.text = instructions
        self.greenLabel.text = message
    }
    
    func startTest() {
    
    }
    
    func takeBrake() {
    
    }
    
    func finishSession() {
    
    }
}
