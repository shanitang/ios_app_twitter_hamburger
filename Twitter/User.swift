//
//  User.swift
//  Twitter
//
//  Created by Yeu-Shuan Tang on 2/22/15.
//  Copyright (c) 2015 Yeu-Shuan Tang. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "userkey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification "

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagLine: String?
    var dictionary: NSDictionary
    var id: Int?
    var profileBackgroundImage: String?
    var follower: Int?
    var following: Int?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagLine = dictionary["description"] as? String
        id = dictionary["id"] as? Int
        profileBackgroundImage = dictionary["profile_background_image_url"] as? String
        follower = dictionary["followers_count"] as? Int
        following = dictionary["friends_count"] as? Int

        
    }
    func logout(){
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User?{
        
        get{
            if _currentUser == nil{
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data !=  nil{
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            if _currentUser != nil{
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                
            }else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey )
            }
            NSUserDefaults.standardUserDefaults().synchronize()

        }
        
    }
}
