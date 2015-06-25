//
//  Experience.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-25.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

import Foundation

enum ExperienceProgress: String {
    case Start = "start"
    case Train1 = "train1"
    case Train2 = "train2"
    case Train3 = "train3"
    case Train4 = "train4"
    case Train5 = "train5"
    case Train6 = "train6"
    case Train7 = "train7"
    case Train8 = "train8"
    case Test = "test"
    case End = "end"
    
    static let allProgressPoints = [Start, Train1, Train2, Train3, Train4, Train5, Train6, Train7, Train8, Test, End]
    static let dateProperties:[String] = {
        var resp = [String]()
        for progressPoint in ExperienceProgress.allProgressPoints {
            resp.append(progressPoint.rawValue + "Date")
        }
        return resp
    }()
}


@objc(Experience)
class Experience : NSObject {
    
    var startDate, endDate: NSDate?
    var train1Date, train2Date, train3Date, train4Date, train5Date, train6Date, train7Date, train8Date: NSDate?
    var testDate: NSDate?
    
    var user: String?
    var progress: ExperienceProgress? {
        willSet {
            if let val = newValue {
                self.setValue(NSDate(), forKey: val.rawValue + "Date")
            }
        }
    }
    
    override convenience init() {
        self.init()
        self.progress = .Start
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        if let username = aDecoder.decodeObjectForKey("username") as? String {
            self.user = username
        }
        if let progress = aDecoder.decodeObjectForKey("progress") as? String {
            self.progress = ExperienceProgress(rawValue: progress)!
        }
        
        //Init all dates:
        for key in ExperienceProgress.dateProperties {
            if let propertyValue = aDecoder.decodeObjectForKey(key) as? String {
                self.setValue(propertyValue, forKey: key)
            }
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let username = self.user {
            aCoder.encodeObject(username, forKey: "username")
        }
        if let progress = self.progress {
            aCoder.encodeObject(progress.rawValue, forKey: "progress")
        }
        //Init all dates:
        for key in ExperienceProgress.dateProperties {
            if let propertyValue = self.valueForKey(key) as? NSDate {
                aCoder.encodeObject(propertyValue, forKey: key)
            }
        }
    }
    
    func preTestStartDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        var components = NSDateComponents()
        components.setValue(4, forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(7, forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(2015, forComponent: NSCalendarUnit.CalendarUnitMonth)
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    func preTestEndDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        var components = NSDateComponents()
        components.setValue(4, forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(7, forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(2015, forComponent: NSCalendarUnit.CalendarUnitMonth)
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    func trainingStartDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        var components = NSDateComponents()
        components.setValue(4, forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(7, forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(2015, forComponent: NSCalendarUnit.CalendarUnitMonth)
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    func trainingEndDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        var components = NSDateComponents()
        components.setValue(17, forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(7, forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(2015, forComponent: NSCalendarUnit.CalendarUnitMonth)
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    func postTestStartDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        var components = NSDateComponents()
        components.setValue(17, forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(7, forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(2015, forComponent: NSCalendarUnit.CalendarUnitMonth)
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    func postTestEndDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        var components = NSDateComponents()
        components.setValue(19, forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(7, forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(2015, forComponent: NSCalendarUnit.CalendarUnitMonth)
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
}