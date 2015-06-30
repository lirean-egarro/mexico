//
//  ScoresViewController.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-26.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import UIKit

let daysOfWeek =  ["SUN","MON","TUE","WED","THU","FRI","SAT"]

class ScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CalendarDayDelegate {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var calendar:UIView!
    @IBOutlet weak var scoreTable:UITableView!
    
    var experience:Experience!
    private var availableScores:[String:Int]?
    private var displayKeys:[AnyObject]?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let dayWidth = calendar.frame.size.width / 7.0
        let yOffset = calendar.frame.size.height / 7.0
        let dayHeight = yOffset
        
        //SPECIFICS FOR JULY CALENDAR:
        for var r = 0 ; r < 6 ; r++ {
            for var d = 0 ; d < 7 ; d++ {
                var tmp:CalendarDay?
                var hasInfo = false
                var title = ""
                var notEmpty = false
                var dayRect = CGRectMake(CGFloat(d)*dayWidth,yOffset+CGFloat(r)*dayHeight - 10.0,dayWidth,dayHeight)
                
                if r == 0 {
                    title = daysOfWeek[d]
                    notEmpty = true
                } else if r == 1 && d > 2 {
                    title = String(d-2)
                    notEmpty = true
                    var thisDate = createJulyDateForDay(d-2)
                    if experience.dictionaryOfScoresForDate(thisDate).count > 0 {
                        hasInfo = true
                    }
                } else if r == 5 && d < 6 {
                    title = String(26+d)
                    notEmpty = true
                    var thisDate = createJulyDateForDay(26+d)
                    if experience.dictionaryOfScoresForDate(thisDate).count > 0 {
                        hasInfo = true
                    }
                } else if r > 1 && r < 5 {
                    title = String((r-1)*7+d-2)
                    notEmpty = true
                    var thisDate = createJulyDateForDay((r-1)*7+d-2)
                    if experience.dictionaryOfScoresForDate(thisDate).count > 0 {
                        hasInfo = true
                    }
                }
                
                if notEmpty {
                    tmp = CalendarDay(frame: dayRect, title: title, hasInfo: hasInfo, isSelectable:r != 0)
                    calendar.addSubview(tmp!)
                    tmp!.delegate = self
                }
            }
        }        
    }
 
    func createJulyDateForDay(day:Int) -> NSDate {
        var components = NSDateComponents()
        components.setValue(day, forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(7, forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(2015, forComponent: NSCalendarUnit.CalendarUnitYear)
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
// MARK: CalendarDayDelegateMethods
    func calandarDayDidTurnOn(day:Int?) {
        if day != nil {
            var thisDate = createJulyDateForDay(day!)
            availableScores = experience.dictionaryOfScoresForDate(thisDate)
            displayKeys = (availableScores! as NSDictionary).allKeys.sorted { ($0 as! String) < ($1 as! String) }
            scoreTable.reloadData()
            
            for tmp in calendar.subviews {
                if tmp.isKindOfClass(CalendarDay) && (tmp as! CalendarDay).mainLabel.text! != String(day!) {
                    (tmp as! CalendarDay).isOn = false
                }
            }
        }
    }
    
// MARK: UITableViewController Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayKeys != nil {
            if displayKeys!.count > 0 {
                return displayKeys!.count
            }
            return 1
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if displayKeys != nil {
            if displayKeys!.count == 0 {
                var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("noContentCell") as! UITableViewCell
                return cell
            } else {
                var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("simpleCell") as! UITableViewCell
                
                let txt = displayKeys![indexPath.row] as! String
                cell.textLabel?.text = txt + String(format:" score: %d",availableScores![txt]!) + "%"
                
                return cell
            }
        } else {
            var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("instructionCell") as! UITableViewCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

