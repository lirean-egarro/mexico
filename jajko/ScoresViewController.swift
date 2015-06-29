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
                var dayRect = CGRectMake(CGFloat(d)*dayWidth,yOffset+CGFloat(r)*dayHeight - 10.0,dayWidth,dayHeight)
                if r == 0 {
                    tmp = CalendarDay(frame: dayRect, title: daysOfWeek[d], hasInfo: false, isSelectable: false)
                } else if r == 1 && d > 2 {
                    tmp = CalendarDay(frame: dayRect, title: String(d-2), hasInfo: false, isSelectable: true)
                } else if r == 5 && d < 3 {
                    tmp = CalendarDay(frame: dayRect, title: String(28+d), hasInfo: true, isSelectable: true)
                } else if r > 1 && r < 5 {
                    tmp = CalendarDay(frame: dayRect, title: String((r-1)*7+d), hasInfo: false, isSelectable: true)
                }
                
                if tmp != nil {
                    calendar.addSubview(tmp!)
                    tmp!.delegate = self
                }
            }
        }
        
    }
 
// MARK: CalendarDayDelegateMethods
    func calandarDayDidTurnOn(id:Int) {
        for tmp in calendar.subviews {
            if tmp.isKindOfClass(CalendarDay) && (tmp as! CalendarDay).udid != id {
                (tmp as! CalendarDay).isOn = false
            }
        }
    }
    
// MARK: UITableViewController Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("simpleCell") as! UITableViewCell
        
        cell.textLabel?.text = "Hello"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

