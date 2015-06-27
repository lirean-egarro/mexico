//
//  Experience.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-25.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//
/*
    This is the class that contains all the hardcoded information regarding this instance of a Jajko study.
    In the future, we may want to move this and create experiences on the fly from config files in JSON.

    Unsure how to achieve this, for example, when it comes to the ExperienceProgress enum.

    Since all the changeable stuff is on this single file, this solution may not be too bad.
*/

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
    static let startDateProperties:[String] = {
        var resp = [String]()
        for progressPoint in ExperienceProgress.allProgressPoints {
            if progressPoint != .End {
                resp.append(progressPoint.rawValue + "BeggingDate")
            } else {
                resp.append(progressPoint.rawValue + "Date")
            }
        }
        return resp
    }()
    static let endDateProperties:[String] = {
        var resp = [String]()
        for progressPoint in ExperienceProgress.allProgressPoints {
            if progressPoint != .End {
                resp.append(progressPoint.rawValue + "EndDate")
            }
        }
        return resp
    }()
}


@objc(Experience)
class Experience : NSObject {
    
    var startBeggingDate, startEndDate: NSDate?
    var train1BeggingDate, train2BeggingDate, train3BeggingDate, train4BeggingDate, train5BeggingDate, train6BeggingDate, train7BeggingDate, train8BeggingDate: NSDate?
    var train1EndDate, train2EndDate, train3EndDate, train4EndDate, train5EndDate, train6EndDate, train7EndDate, train8EndDate: NSDate?
    var testBeggingDate, testEndDate: NSDate?
    var endDate: NSDate?
    
    var pretestBlock1Score, pretestBlock2Score: NSNumber?
    var train1Block1Score, train1Block2Score, train1Block3Score, train1Block4Score: NSNumber?
    var train2Block1Score, train2Block2Score, train2Block3Score, train2Block4Score: NSNumber?
    var train3Block1Score, train3Block2Score, train3Block3Score, train3Block4Score: NSNumber?
    var train4Block1Score, train4Block2Score, train4Block3Score, train4Block4Score: NSNumber?
    var train5Block1Score, train5Block2Score, train5Block3Score, train5Block4Score: NSNumber?
    var train6Block1Score, train6Block2Score, train6Block3Score, train6Block4Score: NSNumber?
    var train7Block1Score, train7Block2Score, train7Block3Score, train7Block4Score: NSNumber?
    var train8Block1Score, train8Block2Score, train8Block3Score, train8Block4Score: NSNumber?
    var posttestBlock1Score, posttestBlock2Score: NSNumber?
    
    var user: String?
    var progress: ExperienceProgress? {
        willSet {
            if let val = newValue {
                if val != .End {
                    self.setValue(NSDate(), forKey: val.rawValue + "BeggingDate")
                } else {
                    self.setValue(NSDate(), forKey: val.rawValue + "Date")
                }
            }
        }
    }
    
    var finishSession:ExperienceProgress? {
        willSet {
            if let val = newValue {
                if val != .End {
                    self.setValue(NSDate(), forKey: val.rawValue + "EndDate")
                } else {
                    self.setValue(NSDate(), forKey: val.rawValue + "Date")
                }
            }
        }
    }
    
   override init() {
        super.init()
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
        for key in ExperienceProgress.startDateProperties {
            if let propertyValue = aDecoder.decodeObjectForKey(key) as? String {
                self.setValue(propertyValue, forKey: key)
            }
        }
        for key in ExperienceProgress.endDateProperties {
            if let propertyValue = aDecoder.decodeObjectForKey(key) as? String {
                self.setValue(propertyValue, forKey: key)
            }
        }
        
        if let p1 = aDecoder.decodeObjectForKey("pretestBlock1Score") as? NSNumber {
            self.pretestBlock1Score = p1
        }
        if let p2 = aDecoder.decodeObjectForKey("pretestBlock2Score") as? NSNumber {
            self.pretestBlock2Score = p2
        }
        if let p3 = aDecoder.decodeObjectForKey("posttestBlock1Score") as? NSNumber {
            self.posttestBlock1Score = p3
        }
        if let p4 = aDecoder.decodeObjectForKey("posttestBlock2Score") as? NSNumber {
            self.posttestBlock2Score = p4
        }
        
        //Init score matrix:
        for var t = 1 ; t <= 8 ; t++ {
            for var s = 1 ; s <= 4 ; s++ {
                let key = String(format:"train%dBlock%dScore",t,s)
                if let propertyValue = aDecoder.decodeObjectForKey(key) as? NSNumber {
                    self.setValue(propertyValue, forKey: key)
                }
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
        //Encode all dates:
        for key in ExperienceProgress.startDateProperties {
            if let propertyValue = self.valueForKey(key) as? NSDate {
                aCoder.encodeObject(propertyValue, forKey: key)
            }
        }
        for key in ExperienceProgress.endDateProperties {
            if let propertyValue = self.valueForKey(key) as? NSDate {
                aCoder.encodeObject(propertyValue, forKey: key)
            }
        }
        
        if let p1 = self.pretestBlock1Score {
            aCoder.encodeObject(p1, forKey: "pretestBlock1Score")
        }
        if let p2 = self.pretestBlock2Score {
            aCoder.encodeObject(p2, forKey: "pretestBlock2Score")
        }
        if let p3 = self.posttestBlock1Score {
            aCoder.encodeObject(p3, forKey: "posttestBlock1Score")
        }
        if let p4 = self.posttestBlock2Score {
            aCoder.encodeObject(p4, forKey: "posttestBlock2Score")
        }
        
        //Encode the matrix! :)
        for var t = 1 ; t <= 8 ; t++ {
            for var s = 1 ; s <= 4 ; s++ {
                let key = String(format:"train%dBlock%dScore",t,s)
                if let propertyValue = self.valueForKey(key) as? NSNumber {
                    aCoder.encodeObject(propertyValue, forKey: key)
                }
            }
        }

    }

    func toJSONDictionary() -> [String:AnyObject] {
        var exp = [String:AnyObject]()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        formatter.timeStyle = .FullStyle
        
        var Pre = [String:AnyObject]()
        if startBeggingDate != nil && startEndDate != nil && pretestBlock1Score != nil && pretestBlock2Score != nil {
            Pre["startdate"] = formatter.stringFromDate(startBeggingDate!)
            Pre["percentages"] = ["block1":pretestBlock1Score!,"block2":pretestBlock2Score!]
            Pre["enddate"] = formatter.stringFromDate(startEndDate!)
        }
        exp["pretest"] = Pre
        
        var Train = [String:AnyObject]()
        for var t = 1 ; t <= 8 ; t++ {
            var Sess = [String:AnyObject]()
            let begKey = String(format:"train%dBeggingDate",t)
            let endKey = String(format:"train%dEndDate",t)
            if let propertyBegVal = self.valueForKey(begKey) as? NSDate,
                let propertyEndVal = self.valueForKey(endKey) as? NSDate {
                    Sess["startdate"] = formatter.stringFromDate(propertyBegVal)
                    Sess["enddate"] = formatter.stringFromDate(propertyEndVal)
                    var Percentages = [String:AnyObject]()
                    for var s = 1 ; s <= 4 ; s++ {
                        let key = String(format:"train%dBlock%dScore",t,s)
                        if let scoreValue = self.valueForKey(key) as? NSNumber {
                            Percentages["block"+String(s)] = scoreValue
                        }
                    }
                    Sess["percentages"] = Percentages
                }
            Train["session"+String(t)] = Sess
        }
        exp["training"] = Train

        var Post = [String:AnyObject]()
        if testBeggingDate != nil && testEndDate != nil && posttestBlock1Score != nil && posttestBlock2Score != nil {
            Post["startdate"] = formatter.stringFromDate(testBeggingDate!)
            Post["percentages"] = ["block1":posttestBlock1Score!,"block2":posttestBlock2Score!]
            Post["enddate"] = formatter.stringFromDate(testEndDate!)
        }
        exp["posttest"] = Post
        
        if endDate != nil {
            exp["completed"] = formatter.stringFromDate(endDate!)
        }
        
        return exp
    }
    
#if DEBUG
    func isCurrentProgressAvailableToday() ->  (ok: Bool, message: String?) {
        return (true,nil)
    }
#else
    func isCurrentProgressAvailableToday() ->  (ok: Bool, message: String?) {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        formatter.timeStyle = .ShortStyle
        
        var now = NSDate()
        var comparePoint = NSDate()
        var resp = now.compare(comparePoint)
        
        switch progress! {
        case .Start:
            comparePoint = preTestStartDate()
            resp = now.compare(comparePoint)
            if resp == .OrderedDescending {
                comparePoint = preTestEndDate()
                resp = now.compare(comparePoint)
                if resp != .OrderedDescending {
                    return (true,nil)
                } else {
                   return (false, "Test no longer available")
                }
            } else {
                return (false, "Available from: \(formatter.stringFromDate(comparePoint))")
            }
        case let p where p == .Train1 || p == .Train2 || p == .Train3 || p == .Train4 || p == .Train5 || p == .Train6 || p == .Train7 || p == .Train8:
            let digit = p.rawValue.substringFromIndex(p.rawValue.endIndex.predecessor()).toInt()!
            comparePoint = trainingStartDate()
            resp = now.compare(comparePoint)
            if resp == .OrderedDescending {
                comparePoint = trainingEndDate()
                resp = now.compare(comparePoint)
                if resp != .OrderedDescending {
                    if digit > 1 {
                        let propertyName = "train" + String(digit-1) + "BeggingDate"
                        comparePoint = self.valueForKey(propertyName) as! NSDate
                        resp = now.compare(comparePoint)
                         if resp == .OrderedDescending {
                            return (true,nil)
                         } else {
                            return (false, "Cannot do two train sessions the same day!")
                         }
                    } else {
                        return (true,nil)
                    }
                } else {
                    return (false, "Training no longer available")
                }
            } else {
                return (false, "Training starts on: \(formatter.stringFromDate(comparePoint))")
            }
        case .Test:
            comparePoint = postTestStartDate()
            resp = now.compare(comparePoint)
            if resp == .OrderedDescending {
                comparePoint = postTestEndDate()
                resp = now.compare(comparePoint)
                if resp != .OrderedDescending {
                    return (true,nil)
                } else {
                    return (false, "Jajko is no longer available")
                }
            } else {
                return (false, "Available from: \(formatter.stringFromDate(comparePoint))")
            }
        case .End:
                return (false, "Thank you for using Jajko!")
        default:
            println("Unknow progress state found")
        }
        
        return (false, "We are sorry: Unknown progress state!")
    }
#endif
    
    func preTestStartDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        var components = NSDateComponents()
        components.setValue(4, forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(7, forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(2015, forComponent: NSCalendarUnit.CalendarUnitYear)
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    func preTestEndDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        var components = NSDateComponents()
        components.setValue(5, forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(7, forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(2015, forComponent: NSCalendarUnit.CalendarUnitYear)
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    func trainingStartDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        var components = NSDateComponents()
        components.setValue(5, forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(7, forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(2015, forComponent: NSCalendarUnit.CalendarUnitYear)
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    func trainingEndDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        var components = NSDateComponents()
        components.setValue(18, forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(7, forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(2015, forComponent: NSCalendarUnit.CalendarUnitYear)
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    func postTestStartDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        var components = NSDateComponents()
        components.setValue(17, forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(7, forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(2015, forComponent: NSCalendarUnit.CalendarUnitYear)
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    func postTestEndDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        var components = NSDateComponents()
        components.setValue(20, forComponent: NSCalendarUnit.CalendarUnitDay)
        components.setValue(7, forComponent: NSCalendarUnit.CalendarUnitMonth)
        components.setValue(2015, forComponent: NSCalendarUnit.CalendarUnitYear)
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
}