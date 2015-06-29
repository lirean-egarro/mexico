//
//  GettingReadyVC.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-26.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

enum SessionMessageType: Int, Printable {
    case Intro = 0, Break, Finish
    var description : String {
        get {
            switch(self) {
            case Intro:
                return "Instructions"
            case Break:
                return "Time for a break"
            case Finish:
                return "All done"
            }
        }
    }
}

class SessionMessageVC: UIViewController {
    
    @IBOutlet weak var whiteLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!

    @IBOutlet weak var messageIcon: UIImageView!
    
    var type: SessionMessageType!
    var navVC:UINavigationController!
    required init(coder aDecoder: NSCoder) {
        println("Don't forget to set the session message type before using this controller!")
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(type:SessionMessageType) {
        self.init()
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navVC = self.navigationController
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var instructions = ""
        var message = ""
        var progress = (navVC as! ExperienceNavigationController).experience.progress!
        
        if type == .Intro {
            self.messageIcon.hidden = true
            self.whiteLabel.hidden = false
            self.view.bringSubviewToFront(whiteLabel)
            
            switch progress {
            case .Start:
                instructions = "This excercise should take you about 30 minutes.\n\n"
                instructions += "The audio button will play the word once more. You will then be presented with two options. Only one option is correct.\n\n"
                instructions += "Make your choice to move on to the next word."
                message = "Listen for the ❔sound in the word displayed.\nPossible answers are:\n\n"
                message += "the [ś] sound, as in: cześć!\n"
                message += "the [sz] sound, as in: co robisz?\n"
                message += "the [ź/z(i)] sound, as in: jeździć\n"
                message += "the [ż] sound, as in: duży"
            case let p where p == .Train1 || p == .Train2 || p == .Train3 || p == .Train4 || p == .Train5 || p == .Train6 || p == .Train7 || p == .Train8:
                instructions = "Focus on the ❔sound (ex. duży).\n\n"
                message =  "Learn:\n\n"
                message += "(1) the sound's acoustic characteristics,\n(2) the sound-to-letter(s) association (ex. sound-to-'ż')"
            case .Test:
                instructions = "Focus on the ❔sound.\nWhich sound is it?"
                message =  "Ready?"
            default:
                println("You shouldn't be here...")
            }
            
            arrowButton.removeTarget(navVC, action: "finishSession", forControlEvents:.TouchUpInside)
            arrowButton.addTarget(navVC, action: "startTest", forControlEvents: .TouchUpInside)
        } else if type == .Break {
            self.messageIcon.hidden = false
            self.whiteLabel.hidden = true
            self.view.bringSubviewToFront(messageIcon)
            
            message = "Done for now!\nBefore you continue... What about a 5 min break?"
            
            arrowButton.removeTarget(navVC, action: "finishSession", forControlEvents:.TouchUpInside)
            arrowButton.addTarget(navVC, action: "startTest", forControlEvents: .TouchUpInside)
        } else if type == .Finish {
            self.messageIcon.hidden = true
            self.whiteLabel.hidden = false
            self.view.bringSubviewToFront(whiteLabel)
            
            if progress == .End {
                instructions = "All done!\nYou've done an excellent job!"
                message = "Don't forget to click on the arrow to send your final results"
            } else {
                instructions = "Good job for today!"
                message = "We will see you tomorrow.\nPress on the arrow to go back to the main menu"
            }
            
            arrowButton.removeTarget(navVC, action: "startTest", forControlEvents:.TouchUpInside)
            arrowButton.addTarget(navVC, action: "finishSession", forControlEvents: .TouchUpInside)
        } else {
            println("Session Message type \(type.description) not supported!")
        }
        
        self.whiteLabel.text = instructions
        self.greenLabel.text = message
    }
}
