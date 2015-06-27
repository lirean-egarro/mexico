//
//  Webservice.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-22.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

class Webservice: NSObject {
    let BACKEND_SYSTEM_SALT:String = "phqfibj9h8fqdiru32r"
    
    typealias WebserviceBooleanClosure = ((response: Bool) -> Void)
    typealias WebserviceThreeWayClosure = ((response: Bool?) -> Void)
    typealias WebserviceStringClosure = ((response: String) -> Void)
    
    var currentUser: String?
    private var sessionToken:String?
    private var session:NSURLSession!
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    class var sharedInstance : Webservice {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : Webservice? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Webservice()
        }
        return Static.instance!
    }
    
    func logout(completion:WebserviceThreeWayClosure? = nil) {
        self.session.invalidateAndCancel()
        self.session = NSURLSession.sharedSession()
        completion?(response: true)
    }
    
    func login(username: String, password: String, completion:WebserviceThreeWayClosure? = nil) {
        
        let url = NSURL(string: "http://54.85.171.8:8082/login")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField:"Content-Type")
        let requestBody:NSDictionary = [
            "user" : username,
            "password" : saltAndEcrypt(password)
        ]
        let postData = NSJSONSerialization.dataWithJSONObject(requestBody, options: .allZeros, error: nil)
        request.HTTPBody = postData
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        session.dataTaskWithRequest(request as NSURLRequest, completionHandler: { (data, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let httpResp = response as? NSHTTPURLResponse {
                if (httpResp.statusCode == 200 || httpResp.statusCode == 210) {
                    self.createNewSession(data, forUser:username)
                    if httpResp.statusCode == 210 {
                        completion?(response: nil) //Half way between false and true :) Questionnaire missing.
                    } else {
                        completion?(response: true)
                    }
                } else {
                    println(NSString(data: data, encoding: NSUTF8StringEncoding))
                    completion?(response: false)
                }
            } else {
                completion?(response: false)
            }
        }).resume()
    }

    func create(username: String, password: String, completion:WebserviceBooleanClosure? = nil) {
        let url = NSURL(string: "http://54.85.171.8:8082/user")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField:"Content-Type")
        let requestBody:NSDictionary = [
            "email" : username,
            "password" : saltAndEcrypt(password)
        ]
        let postData = NSJSONSerialization.dataWithJSONObject(requestBody, options: .allZeros, error: nil)
        request.HTTPBody = postData
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        session.dataTaskWithRequest(request as NSURLRequest, completionHandler: { (data, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let httpResp = response as? NSHTTPURLResponse {
                if (httpResp.statusCode == 200) {
                    self.createNewSession(data, forUser:username)
                    completion?(response: true)
                } else {
                    println(NSString(data: data, encoding: NSUTF8StringEncoding))
                    completion?(response: false)
                }
            } else {
                completion?(response: false)
            }
        }).resume()
    }
    
    func questionnaire(answers:[String:AnyObject], completion:WebserviceBooleanClosure? = nil) {
        if let username = currentUser, let token = self.sessionToken {
            let url = NSURL(string: "http://54.85.171.8:8082/questionnaire")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField:"Content-Type")
            var requestBody = [String:AnyObject]()
            requestBody["cookies"] = ["user": username, "token": token]
            requestBody["answers"] = answers
            if let postData = NSJSONSerialization.dataWithJSONObject(requestBody as NSDictionary, options: .allZeros, error: nil) {
                request.HTTPBody = postData
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                session.dataTaskWithRequest(request as NSURLRequest, completionHandler: { (data, response, error) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    if let httpResp = response as? NSHTTPURLResponse {
                        if (httpResp.statusCode == 200) {
                            completion?(response: true)
                        } else {
                            println(NSString(data: data, encoding: NSUTF8StringEncoding))
                            completion?(response: false)
                        }
                    } else {
                        completion?(response: false)
                    }
                }).resume()
            }
        } else {
            println("Not supposed to call /questionnaire without setting the session user first!")
        }
    }

    func sendExperience(experience:[String:AnyObject], completion:WebserviceBooleanClosure? = nil) {
        if let username = currentUser, let token = self.sessionToken {
            let url = NSURL(string: "http://54.85.171.8:8082/experience")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField:"Content-Type")
            var requestBody = [String:AnyObject]()
            requestBody["cookies"] = ["user": username, "token": token]
            requestBody["experience"] = experience
            if let postData = NSJSONSerialization.dataWithJSONObject(requestBody as NSDictionary, options: .allZeros, error: nil) {
                request.HTTPBody = postData
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                session.dataTaskWithRequest(request as NSURLRequest, completionHandler: { (data, response, error) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    if let httpResp = response as? NSHTTPURLResponse {
                        if (httpResp.statusCode == 200) {
                            completion?(response: true)
                        } else {
                            println(NSString(data: data, encoding: NSUTF8StringEncoding))
                            completion?(response: false)
                        }
                    } else {
                        completion?(response: false)
                    }
                }).resume()
            }
        } else {
            println("Not supposed to call /experience without setting the session user first!")
        }
    }
    
// MARK: Helper Methods:    
    func createNewSession(data: NSData, forUser username:String) {
        self.currentUser = username
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "lastUser")
        
        self.sessionToken = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
        
        var config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        config.HTTPAdditionalHeaders = [
            "cookies" : ["user":username, "token":self.sessionToken!]
        ]
        self.session = NSURLSession(configuration: config)
    }
    
    func saltAndEcrypt(password:String) -> String {
        let new = BACKEND_SYSTEM_SALT + password
        let data = new.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = map(digest) { String(format: "%02hhx", $0) }
        let resp = "".join(hexBytes)
        println(resp)
        return resp
    }
}

