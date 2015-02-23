//
//  PostViewController.swift
//  Twitter
//
//  Created by Yeu-Shuan Tang on 2/22/15.
//  Copyright (c) 2015 Yeu-Shuan Tang. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet var text: UITextView!

    @IBOutlet var screenName: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var picture: UIImageView!
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.screenName.text = self.user?.screenName
        self.name.text = self.user?.name
        var url = self.user?.profileImageUrl
        
        self.picture.setImageWithURL(NSURL(string: url!))
        
        
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tweet(sender: AnyObject) {
        var params = NSMutableDictionary()
        params["status"] = text.text
        
        TwitterClient.sharedInstance.postWithCompletion(params) { (result, error) -> Void in
            if result != nil{
                println("tweet success")
            }else{
                println(error)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
