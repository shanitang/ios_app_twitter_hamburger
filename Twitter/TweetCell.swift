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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
