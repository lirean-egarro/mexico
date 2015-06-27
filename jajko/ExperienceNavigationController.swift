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
        
        (self.viewControllers[0] as! SessionMessageVC).type = .Intro
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
    
    func loadNext() {
        println("Should load next trial")
    }
    
    func startTest() {
        println("Start the test!")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let trialVC = storyboard.instantiateViewControllerWithIdentifier("TrialViewController") as! TrialViewController
        if let firstBlock = session.blocks?[0] {
            if let firstTrial = firstBlock.trials?[0] {
                trialVC.trial = firstTrial
                trialVC.trialIdx = 0
                trialVC.blockSize = firstBlock.trials!.count
                self.pushViewController(trialVC, animated: true)
            } else {
                println("First block doesn't have a first trial")
            }
        } else {
            println("Session doesn't have a first block")
        }
    }
    
    func finishSession() {
        let ud = NSUserDefaults.standardUserDefaults()
        //Store data locally
        if let user = Webservice.sharedInstance.currentUser {
            ud.setObject(NSKeyedArchiver.archivedDataWithRootObject(experience), forKey: "Experience_" + user)
        } else {
            println("This is a fatal error. Sessions must have a currentUser!")
        }
        //Encode and send results
        if experience.progress == .End {
            println("Sending experience to our server...")
            Webservice.sharedInstance.sendExperience(experience.toJSONDictionary(), completion: { (resp) in
                if resp {
                    self.backToDashboard()
                } else {
                    var options:NSDictionary = [
                        "message" : "There was a problem saving your answers. Verify your internet connection and try again. If you decide to cancel now, you will loose all test results!",
                        "yes" : "Cancel",
                        "no" : "Try again"
                    ]
                    PromptManager.sharedInstance.displayAlert(options) { (resp) in
                        if !resp {
                            self.finishSession()
                        }
                    }
                }
            })
        } else {
            backToDashboard()
        }
    }
    
    func backToDashboard() {
        self.performSegueWithIdentifier("finishSession", sender: self)
    }
}

