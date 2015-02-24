//
//  TweetViewController.swift
//  Twitter
//
//  Created by Yeu-Shuan Tang on 2/23/15.
//  Copyright (c) 2015 Yeu-Shuan Tang. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    
    @IBOutlet var text: UILabel!
    @IBOutlet var screenName: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var picture: UIImageView!
    
    var tweet: Tweet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.screenName.text = self.tweet?.user?.screenName
        self.screenName.text = "@" + self.screenName.text!
        self.name.text = self.tweet?.user?.name
        var url = self.tweet?.user?.profileImageUrl
        
        self.picture.setImageWithURL(NSURL(string: url!))
        
        self.text.text = self.tweet?.text


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var navController = segue.destinationViewController as UINavigationController
        var vc = navController.viewControllers[0] as PostViewController
        vc.user = User.currentUser?
        vc.tweet = tweet
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
