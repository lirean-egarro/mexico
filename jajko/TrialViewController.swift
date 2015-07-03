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
    @IBOutlet weak var leftButtonUp: UIButton!
    @IBOutlet weak var rightButtonUp: UIButton!
    @IBOutlet weak var leftButtonDown: UIButton!
    @IBOutlet weak var rightButtonDown: UIButton!
    
    var button_correct:UIButton!
    var button_wrong:[UIButton]
    
    var trial:Trial!
    var trialIdx:Int!
    var trainIdx:Int?
    var blockSize:Int!
    var sessionType:SessionType!
    var feedbacks:Bool
    
    var rightFileName:String
    var wrongFileName:String
    
    private var playCount:Int
    private var buttonLock:Bool
    
    required init(coder aDecoder: NSCoder) {
        playCount = 0
        rightFileName = ""
        wrongFileName = ""
        feedbacks = false
        buttonLock = false
        button_wrong = [UIButton]()
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
        self.leftButtonUp.setBackgroundImage(bg, forState: .Normal)
        self.rightButtonUp.setBackgroundImage(bg, forState: .Normal)
        self.leftButtonDown.setBackgroundImage(bg, forState: .Normal)
        self.rightButtonDown.setBackgroundImage(bg, forState: .Normal)
        
        let strings = trial.displayStrings()

#if DEBUG
        println(strings)
#endif

        self.wordLabel.text = strings.value
        var random:Int = Int(arc4random_uniform(UInt32(100)))
        let left:Bool = random > 49
        random = Int(arc4random_uniform(UInt32(100)))
        let up:Bool = random > 49
        
        if sessionType == SessionType.Training {
        
            switch left {
            case true:
                self.leftButton.tag = 100
                self.leftButton.setTitle(strings.right, forState: .Normal)
                self.button_correct = self.leftButton
                
                self.rightButton.tag = 200
                self.rightButton.setTitle(strings.wrong1, forState: .Normal)
                self.button_wrong.append(self.rightButton)
            case false:
                self.leftButton.tag = 200
                self.leftButton.setTitle(strings.wrong1, forState: .Normal)
                self.button_wrong.append(self.leftButton)
                
                self.rightButton.tag = 100
                self.rightButton.setTitle(strings.right, forState: .Normal)
                self.button_correct = self.rightButton
            default:
                println("If you ever get here, fuck it.")
            }
        } else {
        
            switch (left,up) {
            case (true,true):
                self.leftButtonUp.tag = 100
                self.leftButtonUp.setTitle(strings.right, forState: .Normal)
                self.button_correct = self.leftButtonUp
                
                self.rightButtonUp.tag = 200
                self.rightButtonUp.setTitle(strings.wrong1, forState: .Normal)
                self.button_wrong.append(self.rightButtonUp)
                
                self.leftButtonDown.tag = 200
                self.leftButtonDown.setTitle(strings.wrong2, forState: .Normal)
                self.button_wrong.append(self.leftButtonDown)
                
                self.rightButtonDown.tag = 200
                self.rightButtonDown.setTitle(strings.wrong3, forState: .Normal)
                self.button_wrong.append(self.rightButtonDown)
            case (true,false):
                self.leftButtonDown.tag = 100
                self.leftButtonDown.setTitle(strings.right, forState: .Normal)
                self.button_correct = self.leftButtonDown
                
                self.rightButtonUp.tag = 200
                self.rightButtonUp.setTitle(strings.wrong1, forState: .Normal)
                self.button_wrong.append(self.rightButtonUp)
                
                self.leftButtonUp.tag = 200
                self.leftButtonUp.setTitle(strings.wrong2, forState: .Normal)
                self.button_wrong.append(self.leftButtonUp)
                
                self.rightButtonDown.tag = 200
                self.rightButtonDown.setTitle(strings.wrong3, forState: .Normal)
                self.button_wrong.append(self.rightButtonDown)
            case (false,true):
                self.rightButtonUp.tag = 100
                self.rightButtonUp.setTitle(strings.right, forState: .Normal)
                self.button_correct = self.rightButtonUp
                
                self.leftButtonUp.tag = 200
                self.leftButtonUp.setTitle(strings.wrong1, forState: .Normal)
                self.button_wrong.append(self.leftButtonUp)
                
                self.leftButtonDown.tag = 200
                self.leftButtonDown.setTitle(strings.wrong2, forState: .Normal)
                self.button_wrong.append(self.leftButtonDown)
                
                self.rightButtonDown.tag = 200
                self.rightButtonDown.setTitle(strings.wrong3, forState: .Normal)
                self.button_wrong.append(self.rightButtonDown)
            case (false,false):
                self.rightButtonDown.tag = 100
                self.rightButtonDown.setTitle(strings.right, forState: .Normal)
                self.button_correct = self.rightButtonDown
                
                self.leftButtonUp.tag = 200
                self.leftButtonUp.setTitle(strings.wrong1, forState: .Normal)
                self.button_wrong.append(self.leftButtonUp)
                
                self.rightButtonUp.tag = 200
                self.rightButtonUp.setTitle(strings.wrong2, forState: .Normal)
                self.button_wrong.append(self.rightButtonUp)
                
                self.leftButtonDown.tag = 200
                self.leftButtonDown.setTitle(strings.wrong3, forState: .Normal)
                self.button_wrong.append(self.leftButtonDown)
            default:
                println("Stupid compiler!")
            }
        }
        

        
        self.rightButtonUp.hidden = true
        self.leftButtonUp.hidden = true
        self.rightButtonDown.hidden = true
        self.leftButtonDown.hidden = true
        self.rightButton.hidden = true
        self.leftButton.hidden = true

        
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
            if self.sessionType == SessionType.Training {
                if self.playCount < 2 {
                    self.playButton.enabled = true
                }
                
                self.leftButton.hidden = false
                self.rightButton.hidden = false
            } else {
                self.leftButtonUp.hidden = false
                self.rightButtonUp.hidden = false
                self.leftButtonDown.hidden = false
                self.rightButtonDown.hidden = false
            }
        }
    }
    
    @IBAction func selectedAnswer(sender:AnyObject?) {
    if (!buttonLock) {
        disableButtons()
        
        var tag = (sender as! UIButton).tag
        var resp = false
        if tag == 100 {
            resp = true
        } 
        
        if sessionType == SessionType.Training {
            if trainIdx != nil {
            (self.navigationController! as! ExperienceNavigationController).experience.recordResponseFor(self.trial.minimalPair.ipa1, atTrainSession: trainIdx!, correct: resp)
            }
        }
        
        if feedbacks {
            if resp {
                hightlightCorrect()
                AudioPlayer.sharedInstance.play("correct") {
                    self.wordLabel.text = self.trial.minimalPair.ipa1
                    AudioPlayer.sharedInstance.play(self.rightFileName, delayTime:1.0) {
                        self.enableButtons()
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
                                    self.enableButtons()
                                    (self.navigationController! as! ExperienceNavigationController).loadNextTrial(resp)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            //No feedback! Move on...
            enableButtons()
            (self.navigationController! as! ExperienceNavigationController).loadNextTrial(resp)
        }
    }
    }
    
    func enableButtons() {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.buttonLock = false
            self.leftButton.enabled = true
            self.rightButton.enabled = true
            self.leftButtonUp.enabled = true
            self.rightButtonUp.enabled = true
            self.leftButtonDown.enabled = true
            self.rightButtonDown.enabled = true
        }
    }
    
    func disableButtons() {
        buttonLock = true
        self.leftButton.enabled = false
        self.rightButton.enabled = false
        self.leftButtonUp.enabled = false
        self.rightButtonUp.enabled = false
        self.leftButtonDown.enabled = false
        self.rightButtonDown.enabled = false
    }
    
    func hightlightCorrect() {
        self.containerView.backgroundColor = ControlsConfig.generalGreenColor()
        self.button_correct.layer.shadowColor = ControlsConfig.generalGreenColor().CGColor
        self.button_correct.layer.shadowOffset = CGSizeMake(5, 5)
        self.button_correct.layer.shadowRadius = 5
        self.button_correct.layer.shadowOpacity = 1.0
    }
    
    func hightlightWrong() {
        for button in self.button_wrong {
            self.containerView.backgroundColor = UIColor.redColor()
            button.layer.shadowColor = UIColor.redColor().CGColor
            button.layer.shadowOffset = CGSizeMake(5, 5)
            button.layer.shadowRadius = 5
            button.layer.shadowOpacity = 1.0
        }
    }
}

