//
//  TweetCell.swift
//  Twitter
//
//  Created by Yeu-Shuan Tang on 2/22/15.
//  Copyright (c) 2015 Yeu-Shuan Tang. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet var time: UILabel!
    @IBOutlet var content: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var picture: UIImageView!
    
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    
    var tweet: Tweet!
    
    override func awakeFromNib() {
        
         super.awakeFromNib()
        
        replyButton.setBackgroundImage(UIImage(named: "reply"), forState: UIControlState.Normal)
        retweetButton.setBackgroundImage(UIImage(named: "retweet"), forState: UIControlState.Normal)
        favoriteButton.setBackgroundImage(UIImage(named: "favorite"), forState: UIControlState.Normal)
       
        // Initialization code
    }
    
    func initData(tweet: Tweet){
        
        username.text = tweet.user?.name
        content.text = tweet.text
        var url = tweet.user?.profileImageUrl
        if(url != nil){
            picture.setImageWithURL(NSURL(string: url!) )
        }
        time.text = tweet.time
        self.tweet = tweet
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onReply(sender: UIButton) {
        
        
    }
    
    @IBAction func onRetweet(sender: UIButton) {
        tweet.retweetWithCompletion(nil, completion: { (result, error) -> Void in
            if (result != nil){
                println("Retweet Success")
            }else {
                println(error)
            }
        })
        
        retweetButton.setBackgroundImage(UIImage(named: "retweet_on"), forState: UIControlState.Normal)
    }
    
    @IBAction func onFavorite(sender: UIButton) {
        tweet.favorite { (result, error) -> Void in
            if (result != nil){
                println("Favorite Success")
            }else {
                println(error)
            }
        }
        favoriteButton.setBackgroundImage(UIImage(named: "favorite_on"), forState: UIControlState.Normal)
    }
    
}
