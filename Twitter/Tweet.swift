//
//  Tweet.swift
//  Twitter
//
//  Created by Yeu-Shuan Tang on 2/22/15.
//  Copyright (c) 2015 Yeu-Shuan Tang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createAtString: String? 
    var createAt: NSDate?
    var time: String?
    var id: Int?
    
    init(dictionary: NSDictionary){
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createAt = formatter.dateFromString(createAtString!)
        
        formatter.dateFormat = "HH:mm"
        time = formatter.stringFromDate(createAt!)
      
        id = dictionary["id"] as? Int
    }
    
    class func tweetsWithArray(array: [NSDictionary])-> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in array{
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    
    func favorite(completion: (result: AnyObject?, error: NSError?) -> Void) {
        var params =  NSMutableDictionary()
        params["id"] = self.id

        TwitterClient.sharedInstance.POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(result: response, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(result: nil, error: error)
        })
        
    }
    
    func retweetWithCompletion(params: NSDictionary?, completion: (result: AnyObject?, error: NSError?) -> Void) {
        
        var id = Int()
        id = self.id!
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(result: response, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(result: nil, error: error)
        })
    }
    
}
