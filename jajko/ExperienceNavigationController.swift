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
    
    var currentBlock:Int
    var numberOfBlocks:Int
    var currentBlockScore:Int
    var currentTrial:Int
    
    var progress:ExperienceProgress!
    
    required init(coder aDecoder: NSCoder) {
        currentBlock = 0
        numberOfBlocks = 0
        currentBlockScore = 0
        currentTrial = 0
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("Experience Navigation Controller must load from storyboard!")
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        
        (self.viewControllers[0] as! SessionMessageVC).type = .Intro
        //Create the session!
        progress = experience.progress
        if progress != nil {
            switch progress! {
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
        
        if let num = session.blocks?.count {
            numberOfBlocks = num
        } else {
             println("Session doesn't have blocks")
        }
    }
    
    func loadNextTrial(response:Bool?) {
        //Store the result from previous trial:
        if response == nil {
            currentBlockScore = 0
            currentTrial = 0
            if currentBlock == 0 {
                experience.progress = progress
            }
        } else {
            currentTrial++
            if response! {
                currentBlockScore++
            }
        }
        
        let SB = UIStoryboard(name: "Main", bundle: nil)
        if let thisBlock = session.blocks?[currentBlock] {
            if currentTrial < thisBlock.trials!.count {
                if let thisTrial = thisBlock.trials?[currentTrial] {
                    let trialVC = SB.instantiateViewControllerWithIdentifier("TrialViewController") as! TrialViewController
                    trialVC.trial = thisTrial
                    trialVC.trialIdx = currentTrial
                    trialVC.blockSize = thisBlock.trials!.count
                    self.popViewControllerAnimated(false)
                    self.pushViewController(trialVC, animated: false)
                } else {
                    println("Block \(currentBlock) doesn't have trial \(currentTrial)")
                }
            } else {
                //Finished with all trials in block! Check if there is any more blocks and go to break or finish session:
                if currentBlock < numberOfBlocks - 1 {
                    //Break time
                    (self.viewControllers[0] as! SessionMessageVC).type = .Break
                    
                    //Calculate and store block scores:
                    experience.record(currentBlockScore*100/thisBlock.trials!.count, forBlock: currentBlock+1, atProgress: progress)

                    //Prepeare for next loadNextTrail() call
                    currentBlock++
                } else {
                    //You are done!
                    (self.viewControllers[0] as! SessionMessageVC).type = .Finish
                    
                    //Calculate and store block scores:
                    experience.record(currentBlockScore*100/thisBlock.trials!.count, forBlock: currentBlock+1, atProgress: progress)
                    
                    //Mark this session as completed!
                    experience.finishSession = progress
                }
                
                self.popToRootViewControllerAnimated(true)
            }
        } else {
            println("Session doesn't have block \(currentBlock)!")
        }
    }
    
    func startTest() {
        loadNextTrial(nil)
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

