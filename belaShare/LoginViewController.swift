//
//  ViewController.swift
//  belaShare
//
//  Created by daniel on 3/7/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundViewTopConstraint: NSLayoutConstraint!
    
    var viewIsShifted = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapView))
        //backImageView.addGestureRecognizer(tapRecognizer)
        backgroundView.addGestureRecognizer(tapRecognizer)
        
        passwordField.delegate = self
        
        logInButton.backgroundColor = .clear
        logInButton.layer.borderWidth = 1
        logInButton.layer.borderColor = UIColor.white.cgColor
        logInButton.titleEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        
        signUpButton.backgroundColor = .white
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.titleEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        
    }
    
    func keyboardWillShow(_ notification: NSNotification!)
    {
        //keyboard dimensions
        let keyBoardPosition = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.origin.y
        let viewPosition = backgroundView.frame.origin.y + backgroundView.frame.height
        
        if viewPosition > keyBoardPosition && !viewIsShifted
        {
            self.backgroundViewTopConstraint.constant -= (viewPosition - keyBoardPosition)
            UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded() }
            viewIsShifted = true
        }
        
    }
    
    func keyboardWillHide(_ notification: NSNotification!)
    {
        self.backgroundViewTopConstraint.constant = 40
        UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded() }
        self.viewIsShifted = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
            textField.resignFirstResponder()
        PFUser.logInWithUsername(inBackground: usernameField!.text!, password: passwordField!.text!) { (user: PFUser?, error: Error?) in
            
            if user != nil
            {
                print("logged in")

                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
        return true
    }
    
    func onTapView()
    {
        print("view was tapped")
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        usernameField.text = nil
        passwordField.text = nil
    }
    
    @IBAction func onSignUp(_ sender: UIButton)
    {
        guard let username = usernameField.text else
        {
            self.showMessage(title: "Error", message: "Username is Required")
            return
        }
        
        guard let password = passwordField.text else
        {
            self.showMessage(title: "Error", message: "Enter your password")
            return
        }
        
        let newUser = PFUser()
        
        newUser.username = username
        newUser.password = password
        newUser["profileImage"] = getPFFileFrom(image: #imageLiteral(resourceName: "defaultProfile"))
        newUser["backgImage"] = getPFFileFrom(image: #imageLiteral(resourceName: "userbackg"))
        
        newUser.signUpInBackground {
            
        (success: Bool, error: Error?) in
            
            if success
            {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
            } else {
                
               self.showMessage(title: "Error", message: error!.localizedDescription)
            }
            
        }
    }

    @IBAction func onSignIn(_ sender: UIButton)
    {
        
        PFUser.logInWithUsername(inBackground: usernameField!.text!, password: passwordField!.text!) { (user: PFUser?, error: Error?) in
            
            if user != nil
            {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                self.showMessage(title: "Error", message: error!.localizedDescription)
            }
            
        }
    }

    
}

