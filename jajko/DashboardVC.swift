//
//  DashboardVC.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-22.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

class DashboardVC: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var scoresButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    var experience:Experience?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let ud = NSUserDefaults.standardUserDefaults()

        if let user = Webservice.sharedInstance.currentUser {
            var newExperience = true
            if let data = ud.objectForKey("Experience_" + user) as? NSData {
                experience = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Experience
                newExperience = false
            }
            if newExperience {
                experience = Experience()
                ud.setObject(NSKeyedArchiver.archivedDataWithRootObject(experience!), forKey: "Experience_" + user)
            }
        } else {
            println("Sorry, no user, no experience")
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("Dashboard must load from storyboard!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        formatter.timeStyle = .MediumStyle
        self.dateLabel.text = formatter.stringFromDate(NSDate())
        
        
        switch experience!.progress! {
        case .Start:
            self.startButton.setTitle("READY FOR YOUR FIRST TEST?", forState: .Normal)
        case let p where p == .Train1 || p == .Train2 || p == .Train3 || p == .Train4 || p == .Train5 || p == .Train6 || p == .Train7 || p == .Train8:
            let digit = p.rawValue.substringFromIndex(p.rawValue.endIndex.predecessor())
            self.startButton.setTitle("WELCOME BACK TO TRAIN SESSION " + digit, forState: .Normal)
        case .Test:
            self.startButton.setTitle("WELCOME TO YOUR FINAL TEST!", forState: .Normal)
        case .End:
            self.startButton.setTitle("NO MORE EXCERCISES AVAILABLE", forState: .Normal)
            self.startButton.enabled = false
        default:
            println("Unknow progress state found")
        }
        
        var bg = UIImage(named: "WhiteTile")?.resizableImageWithCapInsets(UIEdgeInsetsMake(7, 7, 7, 7))
        self.scoresButton.setBackgroundImage(bg, forState: .Normal)
        self.logoutButton.setBackgroundImage(bg, forState: .Normal)
    }
    
    @IBAction func cancelToDashboard(segue:UIStoryboardSegue) {
        println("Submission canceled")
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (identifier == "DashToTest") {
            if experience == nil {
                return false
            }
        } else if (identifier == "DashToScores") {
            
        } else if (identifier == "DashToAbout") {
            
        } else if (identifier == "DashLogout") {
            
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "DashToTest") {
            (segue.destinationViewController as! ExperienceReceiver).experience = experience
        } else if (segue.identifier == "DashToScores") {
        
        } else if (segue.identifier == "DashToAbout") {
            
        } else if (segue.identifier == "DashLogout") {
        
        }
    }
}

