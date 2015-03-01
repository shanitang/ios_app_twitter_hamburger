//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Yeu-Shuan Tang on 2/28/15.
//  Copyright (c) 2015 Yeu-Shuan Tang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var tweets = [Tweet]?()
    var params =  NSMutableDictionary()

    @IBOutlet var navigation: UIView!
    @IBOutlet var photo: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var Following: UILabel!
    @IBOutlet var Follower: UILabel!
    
    @IBOutlet var myPhoto: UIImageView!
    @IBOutlet var myName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    
        let f2 = _currentUser?.follower
        let f = "\(f2)"
        println(f)
        
        Follower.text = "\(f2)"

        Following.text = "\(_currentUser?.following)"
//
        params["id"] = _currentUser?.id
        
        TwitterClient.sharedInstance.userTimelineWithParams(params, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            //            println(self.tweets)
        })

        var url = _currentUser?.profileImageUrl
        myPhoto.setImageWithURL(NSURL(string: url!) )
        myName.text = _currentUser?.name

            // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        var tweet = self.tweets?[indexPath.row]
        
        if tweet != nil {
            cell.initData(tweet!)
           
        }
        if cell.replyButton != nil{
            cell.replyButton.addTarget(self, action: "replyAction", forControlEvents: .TouchUpInside)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = tweets?.count as Int!
        
        if(num != nil){
            return num
        }else{
            return 10
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
