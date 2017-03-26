//
//  UserProfileViewController.swift
//  belaShare
//
//  Created by daniel on 3/24/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var backgImageView: PFImageView!
    
    @IBOutlet weak var profileImageView: PFImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var postsTableView: UITableView!
    
    var posts: [Post]?
    var user: PFUser!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.estimatedRowHeight = 500
        postsTableView.rowHeight = UITableViewAutomaticDimension
        postsTableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "postCell")
        
        usernameLabel.text = user.username
        nameLabel.text = user.username
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.file = user["profileImage"] as? PFFile
        profileImageView.loadInBackground()
        
        backgImageView.file = user["backgImage"] as? PFFile
        backgImageView.loadInBackground()
        
        posts = []
        getPosts()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        if (navigationController?.topViewController != self) {
            navigationController?.isNavigationBarHidden = false
        }
        super.viewWillDisappear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
        cell.post = posts?[indexPath.row]
        return cell
    }
    
    func getPosts()
    {
        ParseClient.getPosts(of: user)
        {
            (data: [PFObject]?, error: Error?) in
            
            if error == nil
            {
                guard let data = data else { return }
                
                for object in data
                {
                    let post = Post(object: object)
                    self.posts?.append(post)
                }
                
                self.postsTableView.reloadData()
            }
            
            
        }
    }


    @IBAction func onBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    
}
