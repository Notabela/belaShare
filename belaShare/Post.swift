//
//  Post.swift
//  belaShare
//
//  Created by daniel on 3/16/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject
{
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    
    var highResMedia: PFFile?
    var lowResMedia: PFFile?
    var author: PFUser?
    var caption: String?
    var likesCount: UInt
    var commentsCount: UInt
    var timeCreated: Date
    
    var shortTimeStamp: String
    {
        return DateFormatter.timeSince(from: timeCreated)
    }
    
    init(highResMedia: PFFile?, lowResMedia: PFFile?, caption: String?, author: PFUser?, likesCount: UInt = 0, commentsCount: UInt = 0, timeCreated: Date = Date())
    {
        self.highResMedia = highResMedia
        self.lowResMedia = lowResMedia
        self.caption = caption
        self.author = author
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.timeCreated = timeCreated
    }
    
    convenience init(object: PFObject)
    {
        let highResMedia = object["highResMedia"] as? PFFile
        let lowResMedia = object["lowResMedia"] as? PFFile
        let author = object["author"] as? PFUser
        let caption = object["caption"] as? String
        let likesCount = object["likesCount"] as! UInt
        let commentsCount = object["commentsCount"] as! UInt
        let date = object.createdAt!
        
        self.init(highResMedia: highResMedia, lowResMedia: lowResMedia, caption: caption, author: author, likesCount: likesCount, commentsCount: commentsCount, timeCreated: date)
    }
    
    private func convertToPFObject() -> PFObject
    {
        let post = PFObject(className: "Post")
        post["highResMedia"] = highResMedia
        post["lowResMedia"] = lowResMedia
        post["author"] = author
        post["caption"] = caption
        post["likesCount"] = likesCount
        post["commentsCount"] = commentsCount
        
        return post
    }
    
    func postToServer(withCompletion completion: PFBooleanResultBlock?)
    {
        convertToPFObject().saveInBackground(block: completion)
    }
    
    

}
