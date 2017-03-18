//
//  ParseClient.swift
//  belaShare
//
//  Created by daniel on 3/16/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import Parse

class ParseClient: Parse
{
    private override init() {}
    
    class func authenticate()
    {
        // Initialize Parse
        // Set applicationId and server based on the values in the Heroku settings.
        // clientKey is not used on Parse open source unless explicitly configured
        Parse.initialize(with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) in
            configuration.applicationId = "belaShare"
            configuration.clientKey = "aklsdfy8oi2tntgy8sd9oijklqweiy0842ythijfgmasdnklhgy8"
            configuration.server = "https://intense-forest-94674.herokuapp.com/parse"
        }))
    }
    
    class func getPosts(withCompletion completion: @escaping ([PFObject]?, Error?) -> Void)
    {
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        
        query.findObjectsInBackground
        {
            (posts: [PFObject]?, error: Error?) in
            
                completion(posts, error)
        }
        

    }
    
    
}
