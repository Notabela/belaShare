//
//  HomeViewController.swift
//  belaShare
//
//  Created by daniel on 3/13/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import KVNProgress

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PostCellDelegate
{

    @IBOutlet weak var postsTableView: UITableView!
    var posts: [Post]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Create a refreshControl Element and customize if you want
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.lightGray
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(onPullToRefresh(_:)), for: UIControlEvents.valueChanged)
        postsTableView.insertSubview(refreshControl, at: 0)
        
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.estimatedRowHeight = 500
        postsTableView.rowHeight = UITableViewAutomaticDimension
        postsTableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "postCell")
        
        posts = []
        getPosts()
    }
    
    internal func usernameLabelWasTapped(_ user: PFUser)
    {
        performSegue(withIdentifier: "profileSegue", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destVC = segue.destination as! UserProfileViewController
        destVC.user = sender as! PFUser
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
        
        cell.delegate = self
        cell.post = posts?[indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        //create header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        //create imageview and round it
        let profileView = PFImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        //add touchRecognizer to profileView

        profileView.file = posts?[section].author?["profileImage"] as? PFFile
        profileView.loadInBackground()
        
        headerView.addSubview(profileView)
        
        // Add a UILabel for the username here
        let userLabel = UILabel(frame: CGRect(x:50, y: 10, width: 200, height: 30))
        userLabel.text = (posts?[section])?.author?.username
        headerView.addSubview(userLabel)
        
        //Add TimeStamp label
        let timeStampLabel = UILabel(frame: CGRect(x: view.frame.width - 35, y: 10, width: 50, height: 30))
        timeStampLabel.text = posts?[section].shortTimeStamp
        headerView.addSubview(timeStampLabel)
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }
    
    func getPosts()
    {
        KVNProgress.show()
        
        ParseClient.getPosts
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
                KVNProgress.dismiss()
            }
            
        }
    }
    
    func onPullToRefresh(_ sender: UIRefreshControl?)
    {
        ParseClient.getPosts
            {
                (data: [PFObject]?, error: Error?) in
                
                if error == nil
                {
                    guard let data = data else { return }
                    self.posts = []
                    
                    for object in data
                    {
                        let post = Post(object: object)
                        self.posts?.append(post)
                    }
                    
                    self.postsTableView.reloadData()
                    sender?.endRefreshing()
                }
                
        }
    }

}

protocol PostCellDelegate: class
{
    func usernameLabelWasTapped(_ user: PFUser)
}
