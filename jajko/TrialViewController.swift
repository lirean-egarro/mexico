//
//  TrialViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-26.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class TrialViewController: UIViewController {
    
    @IBOutlet weak var containerView:UIView!
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var button_correct:UIButton!
    var button_wrong:UIButton!
    
    var trial:Trial!
    var trialIdx:Int!
    var trainIdx:Int?
    var blockSize:Int!
    var sessionType:SessionType!
    var feedbacks:Bool
    
    var rightFileName:String
    var wrongFileName:String
    
    private var playCount:Int
    
    required init(coder aDecoder: NSCoder) {
        playCount = 0
        rightFileName = ""
        wrongFileName = ""
        feedbacks = false
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("Experience Navigation Controller must load from storyboard!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bg = UIImage(named: "WhiteTile")?.resizableImageWithCapInsets(UIEdgeInsetsMake(7, 7, 7, 7))
        self.leftButton.setBackgroundImage(bg, forState: .Normal)
        self.rightButton.setBackgroundImage(bg, forState: .Normal)
        
        let strings = trial.displayStrings()
        
        self.wordLabel.text = strings.value
        if Int(arc4random_uniform(UInt32(100))) > 49 {
            self.leftButton.tag = 100
            self.leftButton.setTitle(strings.right, forState: .Normal)
            self.button_correct = self.leftButton

            self.rightButton.tag = 200
            self.rightButton.setTitle(strings.wrong, forState: .Normal)
            self.button_wrong = self.rightButton
        } else {
            self.leftButton.tag = 200
            self.leftButton.setTitle(strings.wrong, forState: .Normal)
            self.button_wrong = self.leftButton
            
            self.rightButton.tag = 100
            self.rightButton.setTitle(strings.right, forState: .Normal)
            self.button_correct = self.rightButton
        }
        
        self.progressLabel.text = String(format:"%d/%d",trialIdx+1,blockSize)
        
        rightFileName = self.trial.audioFileName()
        wrongFileName = self.trial.complementaryFileName()!
        
        self.playButton.enabled = false
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.play(nil)
        }
    }
    
    @IBAction func play(sender:AnyObject?) {
        self.playCount++
        self.playButton.enabled = false
        AudioPlayer.sharedInstance.play(rightFileName) {
            if self.playCount < 2 {
                self.playButton.enabled = true
            } else {
                self.leftButton.hidden = false
                self.rightButton.hidden = false
            }
        }
    }
    
    @IBAction func selectedAnswer(sender:AnyObject?) {
        var tag = (sender as! UIButton).tag
        var resp = false
        if tag == 100 {
            resp = true
        } 
        
        if sessionType == SessionType.Training {
            if trainIdx != nil {
            (self.navigationController! as! ExperienceNavigationController).experience.recordResponseFor(self.trial.minimalPair.ipa1, atTrainSession: trainIdx! + 1, correct: resp)
            }
        }
        
        if feedbacks {
            if resp {
                hightlightCorrect()
                AudioPlayer.sharedInstance.play("correct") {
                    self.wordLabel.text = self.trial.minimalPair.ipa1
                    AudioPlayer.sharedInstance.play(self.rightFileName, delayTime:1.0) {
                        (self.navigationController! as! ExperienceNavigationController).loadNextTrial(resp)
                    }
                }
            } else {
                hightlightWrong()
                AudioPlayer.sharedInstance.play("wrong") {
                    self.wordLabel.text = self.trial.minimalPair.ipa1
                    AudioPlayer.sharedInstance.play(self.rightFileName, delayTime:1.0) {
                        self.wordLabel.text = self.trial.minimalPair.ipa2
                        AudioPlayer.sharedInstance.play(self.wrongFileName, delayTime:1.0) {
                            self.wordLabel.text = self.trial.minimalPair.ipa1
                            AudioPlayer.sharedInstance.play(self.rightFileName, delayTime:1.0) {
                                self.wordLabel.text = self.trial.minimalPair.ipa2
                                AudioPlayer.sharedInstance.play(self.wrongFileName, delayTime:1.0) {
                                    (self.navigationController! as! ExperienceNavigationController).loadNextTrial(resp)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            //No feedback! Move on...
            (self.navigationController! as! ExperienceNavigationController).loadNextTrial(resp)
        }
    }
    
    func hightlightCorrect() {
        self.containerView.backgroundColor = ControlsConfig.generalGreenColor()
        self.button_correct.layer.shadowColor = ControlsConfig.generalGreenColor().CGColor
        self.button_correct.layer.shadowOffset = CGSizeMake(5, 5)
        self.button_correct.layer.shadowRadius = 5
        self.button_correct.layer.shadowOpacity = 1.0
    }
    
    func hightlightWrong() {
        self.containerView.backgroundColor = UIColor.redColor()
        self.button_wrong.layer.shadowColor = UIColor.redColor().CGColor
        self.button_wrong.layer.shadowOffset = CGSizeMake(5, 5)
        self.button_wrong.layer.shadowRadius = 5
        self.button_wrong.layer.shadowOpacity = 1.0
    }
}

