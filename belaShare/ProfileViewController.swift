//
//  ProfileViewController.swift
//  belaShare
//
//  Created by daniel on 3/13/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onLogOut(_ sender: UIBarButtonItem)
    {
        PFUser.logOutInBackground { (error: Error?) in
            if error == nil
            {
              self.tabBarController?.dismiss(animated: true, completion: nil)
            }
        }
        
    }

}
