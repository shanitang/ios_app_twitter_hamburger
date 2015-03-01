//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Yeu-Shuan Tang on 2/22/15.
//  Copyright (c) 2015 Yeu-Shuan Tang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController{
    
    var trayOriginalCenter: CGPoint!
    var origianlPoint: CGFloat!
    var offset: CGFloat!
    var left: CGFloat!
    var rightBound: CGFloat!
    var right: CGFloat!
    
    private var profileVC: ProfileViewController!
    private var mentionVC: MentionViewController!
    private var timelineVC: TweetsViewController!
    private var userVC: UserProfileViewController!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var burger: UIView!
    
    var tweets = [Tweet]?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        rightBound = containerView.bounds.maxX
        
        right = rightBound * 1.5 - 44
        left = rightBound / 2
        
        
        timelineVC = storyboard?.instantiateViewControllerWithIdentifier("TweetsViewController") as? TweetsViewController
        
        mentionVC = storyboard?.instantiateViewControllerWithIdentifier("MentionView") as? MentionViewController
        
        profileVC = storyboard?.instantiateViewControllerWithIdentifier("ProfileView") as? ProfileViewController
        
        userVC = storyboard?.instantiateViewControllerWithIdentifier("UserProfile") as? UserProfileViewController
        

        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
        })

        self.containerView.addSubview(timelineVC.view)

        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func hamburger(panGestureRecognizer: UIPanGestureRecognizer) {
        
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            origianlPoint = point.x
            trayOriginalCenter = containerView.center

            
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
       
        displayVC(timelineVC)
    }
    
    @IBAction func onMentions(sender: UIButton) {
        displayVC(mentionVC)
    }
    
    @IBAction func onProfile(sender: UIButton) {
        
        displayVC(profileVC)
    }
    
    func displayVC(vc: UIViewController){
        
        
        self.addChildViewController(vc)
        self.containerView.addSubview(vc.view)
        
        vc.didMoveToParentViewController(self)
        
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.containerView.center = CGPoint(x: 160, y: self.trayOriginalCenter.y)
        })
 
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "userVIew"{
        var navController = segue.destinationViewController as UINavigationController
        var vc = navController.viewControllers[0] as UserProfileViewController
        
        let indexPath = timelineVC.tableView.indexPathForCell(sender as TweetCell)!
        let tweet = self.tweets?[indexPath.row]
        vc.tweet = tweet
        }

    
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    
    
}
