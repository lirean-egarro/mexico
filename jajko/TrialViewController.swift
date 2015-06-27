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
    
    required init(coder aDecoder: NSCoder) {
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
    }
    
    @IBAction func play(sender:AnyObject?) {
        println("Should play file")
    }
}

