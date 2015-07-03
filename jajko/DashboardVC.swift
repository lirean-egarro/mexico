//
//  DashboardVC.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-22.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

class DashboardVC: UIViewController, NavigationPusher {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var scoresButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var experience:Experience?
    weak var nextController:UIViewController?
    
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
        self.scoresButton.hidden = true
        self.logoutButton.hidden = true
        self.aboutButton.hidden = true
        self.startButton.enabled = false
        
        self.indicator.startAnimating()
        self.startButton.setTitle("Please wait while we update your records...", forState: .Normal)
        Webservice.sharedInstance.getExperience(completion: { (experienceDict) in
            if experienceDict != nil {
                //Keep the oldest!
                var downloadedExperience = Experience(fromDictionary: experienceDict!)
                if downloadedExperience > self.experience! {
                    self.experience = downloadedExperience
                    self.layoutSubviews()
                } else if self.experience! > downloadedExperience {
                    Webservice.sharedInstance.sendExperience(self.experience!.toJSONDictionary(), completion: { (resp) in
                        if !resp {
                            println("1) We are having problems uploading this user's experience :(")
                        }
                        self.layoutSubviews()
                    })
                } else {
                    println("Everything in sync!")
                    self.layoutSubviews()
                }
            } else {
                //No remote experience found! Must be a new user. If not, upload experience!
                if self.experience!.progress != .Start {
                    Webservice.sharedInstance.sendExperience(self.experience!.toJSONDictionary(), completion: { (resp) in
                        if !resp {
                            println("2) We are having problems uploading this user's experience :(")
                        }
                        self.layoutSubviews()
                    })
                } else {
                    self.layoutSubviews()
                }
            }
        })
    }
    
    func layoutSubviews() {
        dispatch_async(dispatch_get_main_queue()) {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .FullStyle
            formatter.timeStyle = .MediumStyle
            self.dateLabel.text = formatter.stringFromDate(NSDate())
            
            let availability = self.experience!.isCurrentProgressAvailableToday()
            
            self.indicator.stopAnimating()
            self.scoresButton.hidden = false
            self.logoutButton.hidden = false
            self.aboutButton.hidden = false
            self.startButton.enabled = true
            
            self.startButton.titleLabel?.numberOfLines = 2
            self.startButton.titleLabel?.textAlignment = .Center
            if availability.ok {
                switch self.experience!.progress! {
                case .Start:
                    self.startButton.setTitle("READY FOR YOUR FIRST TEST?", forState: .Normal)
                case let p where p == .Train1 || p == .Train2 || p == .Train3 || p == .Train4 || p == .Train5 || p == .Train6 || p == .Train7 || p == .Train8:
                    let digit = String(p.trainIdx()!)
                    self.startButton.setTitle("WELCOME BACK TO TRAIN SESSION " + digit, forState: .Normal)
                case .Test:
                    self.startButton.setTitle("WELCOME TO YOUR FINAL TEST!", forState: .Normal)
                case .End:
                    self.startButton.setTitle("NO MORE EXERCISES AVAILABLE", forState: .Normal)
                    self.startButton.enabled = false
                default:
                    println("Unknow progress state found")
                }
            } else {
                self.startButton.setTitle("", forState: .Normal)
                self.startButton.enabled = false
                
                self.view.bringSubviewToFront(self.errorLabel)
                self.errorLabel.text = availability.message
                self.errorLabel.hidden = false
            }
            
            var bg = UIImage(named: "WhiteTile")?.resizableImageWithCapInsets(UIEdgeInsetsMake(7, 7, 7, 7))
            self.scoresButton.setBackgroundImage(bg, forState: .Normal)
            self.logoutButton.setBackgroundImage(bg, forState: .Normal)
        }
    }

    @IBAction func finishSessionIntoDashboard(segue:UIStoryboardSegue) {
        layoutSubviews()
        nextController = self
    }
    
    @IBAction func cancelToDashboard(segue:UIStoryboardSegue) {
        println("Back into dashboard")
        nextController = self
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (identifier == "DashToTest") {
            if experience == nil {
                return false
            }
        } else if (identifier == "DashToScores") {
            if experience == nil {
                return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "DashToTest") {
            nextController = segue.destinationViewController as? UIViewController
            (nextController as! ExperienceNavigationController).experience = experience
        } else if (segue.identifier == "DashToScores") {
            nextController = segue.destinationViewController as? UIViewController
            (nextController as! ScoresViewController).experience = experience
        }
    }
}

