//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Yeu-Shuan Tang on 2/22/15.
//  Copyright (c) 2015 Yeu-Shuan Tang. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets = [Tweet]?()

    var refreshControl: UIRefreshControl!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //page refresh controller
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
//            println(self.tweets)
        })
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        self.navigationItem.title = "Home"


        // Do any additional setup after loading the view.
    }
    
    func onRefresh() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        User.currentUser?.logout()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            //            println(self.tweets)
        })
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        var tweet = self.tweets?[indexPath.row]
        
        if tweet != nil {
            cell.initData(tweet!)
            cell.imageButton.addTarget(self, action: "showUserProfile", forControlEvents: .TouchUpInside)
        }

        return cell
    }
    
    func showUserProfile(){
        self.performSegueWithIdentifier("userView", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = tweets?.count as Int!
        
        if(num != nil){
            return num
        }else{
            return 10
        }
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "userView"{
            
            var navController = segue.destinationViewController as UINavigationController
            var vc = navController.viewControllers[0] as UserProfileViewController
            
            var kk = sender as UIButton
            let bb = kk.superview?.superview as TweetCell
            let indexPath = tableView.indexPathForCell(bb)!
            let tweet = self.tweets?[indexPath.row]
            vc.tweet = tweet
        }

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
