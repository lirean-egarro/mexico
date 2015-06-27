//
//  TrialViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-26.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

class TrialViewController: UIViewController {
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var trial:Trial!
    var trialIdx:Int!
    var blockSize:Int!
    
    private var playCount:Int
    
    required init(coder aDecoder: NSCoder) {
        playCount = 0
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
            self.rightButton.tag = 200
            self.rightButton.setTitle(strings.wrong, forState: .Normal)
        } else {
            self.leftButton.tag = 200
            self.leftButton.setTitle(strings.wrong, forState: .Normal)
            self.rightButton.tag = 100
            self.rightButton.setTitle(strings.right, forState: .Normal)
        }
        
        self.progressLabel.text = String(format:"%d/%d",trialIdx+1,blockSize)
    }
    
    @IBAction func play(sender:AnyObject?) {
        self.playCount++
        if playCount == 2 {
            self.leftButton.hidden = false
            self.rightButton.hidden = false
        }
    }
    
    @IBAction func selectedAnswer(sender:AnyObject?) {
        var tag = (sender as! UIButton).tag
        var resp = false
        if tag == 100 {
            resp = true
        }
        
        (self.navigationController! as! ExperienceNavigationController).loadNextTrial(resp)
    }
}

