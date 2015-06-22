//
//  Webservice.swift
//  jajko
//
//  Created by Esteban Garro on 2015-06-22.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

class Webservice: NSObject {
    typealias WebserviceBooleanClosure = ((response: Bool) -> Void)
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
    
    func login(username: String, password: String, completion:WebserviceBooleanClosure? = nil) {
        
        let url = NSURL(string: "http://54.85.171.8:8082/login")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField:"Content-Type")
        let requestBody:NSDictionary = [
            "user" : username,
            "password" : password
        ]
        let postData = NSJSONSerialization.dataWithJSONObject(requestBody, options: .allZeros, error: nil)
        request.HTTPBody = postData
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        session.dataTaskWithRequest(request as NSURLRequest, completionHandler: { (data, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let httpResp = response as? NSHTTPURLResponse {
                if (httpResp.statusCode == 200) {
                    self.sessionToken = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
                    NSUserDefaults.standardUserDefaults().setObject(username, forKey: "lastUser")
                    var config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
                    config.HTTPAdditionalHeaders = [
                        "cookies" : ["user":username, "token":self.sessionToken!]
                    ]
                    self.session = NSURLSession(configuration: config)
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

    func create(username: String, password: String, completion:WebserviceBooleanClosure? = nil) {
        
    }
    
    func questionnaire(answers:[String:AnyObject], completion:WebserviceBooleanClosure? = nil) {
    
    }
}

