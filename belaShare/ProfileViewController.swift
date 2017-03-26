//
//  ProfileViewController.swift
//  belaShare
//
//  Created by daniel on 3/13/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import Parse
import ParseUI

enum imageDestination
{
    case profileImageView, backgImageView
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var backgImageView: PFImageView!
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var postsTableView: UITableView!
    
    var posts: [Post]?
    var user: PFUser = PFUser.current()! //default value
    
    var destination: imageDestination?

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
        
        let profileGestureRecognizer = UILongPressGestureRecognizer()
        profileGestureRecognizer.addTarget(self, action: #selector(onHoldProfileImage(_:)))
        profileImageView.addGestureRecognizer(profileGestureRecognizer)
        
        let backgGestureRecognizer = UILongPressGestureRecognizer()
        backgGestureRecognizer.addTarget(self, action: #selector(onHoldBackgImage(_:)))
        backgImageView.addGestureRecognizer(backgGestureRecognizer)
        
        posts = []
        getPosts()
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
    
    func onHoldBackgImage(_ sender: UILongPressGestureRecognizer)
    {
        destination = .backgImageView
        showPickerView()
    }
    
    func onHoldProfileImage(_ sender: UILongPressGestureRecognizer)
    {
        destination = .profileImageView
        showPickerView()
    }
    
    func showPickerView()
    {
        let actionSheet = UIAlertController(title: "New Post", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default) { action in self.showCamera() })
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default)  { action in self.showAlbum()  })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.modalPresentationStyle = .popover
        actionSheet.preferredContentSize = CGSize(width: 50, height: 50)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            
            if self.destination == .profileImageView
            {
                let resizedImage = image.resized(to: CGSize(width: 500, height: 500))
                let PFImage = getPFFileFrom(image: resizedImage)
                profileImageView.image = resizedImage
                PFUser.current()?["profileImage"] = PFImage
                PFUser.current()?.saveInBackground()
            }
            else
            {
                let resizedImage = image.resized(to: CGSize(width: 640, height: 200))
                let PFImage = getPFFileFrom(image: resizedImage)
                backgImageView.image = resizedImage
                PFUser.current()?["backgImage"] = PFImage
                PFUser.current()?.saveInBackground()
            }
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {

            if self.destination == .profileImageView
            {
                let resizedImage = image.resized(to: CGSize(width: 500, height: 500))
                let PFImage = getPFFileFrom(image: resizedImage)
                profileImageView.image = resizedImage
                PFUser.current()?["profileImage"] = PFImage
                PFUser.current()?.saveInBackground()
            }
            else
            {
                let resizedImage = image.resized(to: CGSize(width: 640, height: 200))
                let PFImage = getPFFileFrom(image: resizedImage)
                backgImageView.image = resizedImage
                PFUser.current()?["backgImage"] = PFImage
                PFUser.current()?.saveInBackground()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func showCamera()
    {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum()
    {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
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

    @IBAction func OnLogOut(_ sender: Any)
    {
        PFUser.logOutInBackground { (error: Error?) in
            if error == nil
            {
                print("logged out")
                self.dismiss(animated: true, completion: nil)
                self.tabBarController?.dismiss(animated: true, completion: nil)
            }
        }
    }


}
