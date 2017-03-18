//
//  PostCell.swift
//  belaShare
//
//  Created by daniel on 3/16/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostCell: UITableViewCell
{

    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: Post?
    {
        didSet
        {
            postImageView.file = post!.media
            postImageView.loadInBackground()
            userNameLabel.text = post!.author?.username
            likesLabel.text = "\(post!.likesCount) Likes"
           
            if let caption = post?.caption
            {
                let user = post?.author?.username
                let s = NSMutableAttributedString(string: user! + "  " + caption, attributes: [:])
                let color = UIColor.clear
                s.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, (user?.characters.count)!))
                captionLabel.attributedText = s
            }
            
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onLikePost(_ sender: UIButton)
    {
       print("post was liked")
    }
    
    @IBAction func onComment(_ sender: UIButton)
    {
       print("commented on post")
    }
    
    
}
