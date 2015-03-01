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
    
    var trayOriginalCenter: CGPoint!
    var origianlPoint: CGFloat!
    var offset: CGFloat!
    var left: CGFloat!
    var rightBound: CGFloat!
    var right: CGFloat!
    
    private let profileVC = ProfileViewController()
    private let mentionVC =  MentionViewController()
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var burger: UIView!
    
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
        
        rightBound = containerView.bounds.maxX
       
        


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
            cell.replyButton.addTarget(self, action: "replyAction", forControlEvents: .TouchUpInside)
        }
        
        return cell
    }
    
    func replyAction(){
        self.performSegueWithIdentifier("PostView", sender: self)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = tweets?.count as Int!
        
        if(num != nil){
            return num
        }else{
            return 10
        }
        
    }
    
    @IBAction func hamburger(panGestureRecognizer: UIPanGestureRecognizer) {
        
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)

        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            origianlPoint = point.x
            trayOriginalCenter = containerView.center
            right = rightBound * 1.5 - 44
            left = rightBound / 2

        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            offset = origianlPoint - trayOriginalCenter.x
            var x = (point.x - offset) > right ? right : (point.x - offset)
            if x < left{
                x = left
            }

            containerView.center = CGPoint(x: x, y: trayOriginalCenter.y)
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if velocity.x > 0 {
                    self.containerView.center = CGPoint(x: self.right, y: self.trayOriginalCenter.y)
                    
                }
                else if velocity.x < 0{
                    self.containerView.center = CGPoint(x: self.left, y: self.trayOriginalCenter.y)
                }

            })
            
        }
    }
    
    @IBAction func onTimeline(sender: UIButton) {
    }
    
    @IBAction func onMentions(sender: UIButton) {
    }
    
    @IBAction func onProfile(sender: UIButton) {
        self.addChildViewController(profileVC)
        self.containerView.addSubview(profileVC.view)
        
        profileVC.didMoveToParentViewController(self)
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
