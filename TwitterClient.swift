//
//  TwitterClient.swift
//  Twitter
//
//  Created by Yeu-Shuan Tang on 2/22/15.
//  Copyright (c) 2015 Yeu-Shuan Tang. All rights reserved.
//

import UIKit

let twitterConsumerKey = "OjgYSBj7UeAqLM9xBG7j7PxV6"
let twitterConsumerSecret = "uxsd0lzQU3YNT8BPD5VLZqIiRtEZkMq9hP6mqVuhc1DXTNdz1S"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient{
        struct Static {
            static let instance =
            TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://auth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                println(error)
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
    func homeTimelineWithParams (params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets: tweets, error: nil)
//            print(response)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(tweets: nil, error: error)
        })

    }
    
    func userTimelineWithParams (params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        TwitterClient.sharedInstance.GET("1.1/statuses/user_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets: tweets, error: nil)
            //            print(response)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(tweets: nil, error: error)
        })
        
    }
    
    func mentionsTimelineWithParams (params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        var params =  NSMutableDictionary()
        TwitterClient.sharedInstance.GET("1.1/statuses/mentions_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets: tweets, error: nil)
            //            print(response)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(tweets: nil, error: error)
        })
        
    }
    

    
    
    func openUrl(url :NSURL){
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
//                println("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println(error)
                    self.loginCompletion?(user: nil, error: error)
            })
            
            }, failure: { (error: NSError!) -> Void in
                println("Faliled")
                self.loginCompletion?(user: nil, error: error)
        })

    }
    
    func postWithCompletion(params: NSDictionary?, completion: (result: AnyObject?, error: NSError?) -> Void) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(result: response, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(result: nil, error: error)
        })
    }
   
}
