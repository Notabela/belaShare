//
//  CaptionViewController.swift
//  belaShare
//
//  Created by daniel on 3/14/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import Parse

class CaptionViewController: UIViewController, UITextViewDelegate
{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var image: UIImage!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imageView.image = image
        backgroundView.image = image
        backgroundView.addDarkBlur()
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(onTapView))
        backgroundView.addGestureRecognizer(tapRecognizer)

        textView.becomeFirstResponder()
        textView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars <= 140
    }

    @IBAction func onShare(_ sender: UIBarButtonItem)
    {
        let resizedImage = image.resized(to: CGSize(width: 1080, height: 1080))
        let PFImageFile = getPFFileFrom(image: resizedImage)
 
        let post = Post(image: PFImageFile, caption: textView.text, author: PFUser.current())
        post.postToServer
        {
            (success: Bool, error: Error?) in
            
            if error == nil
            {

                print("image was posted")
            }
        }
        
        if let navController = self.navigationController, navController.viewControllers.count >= 2
        {
            let viewController = navController.viewControllers[navController.viewControllers.count - 2] as! CaptureViewController
            viewController.imageWasPicked = false
            viewController.imageView.image = nil
        }
        
        tabBarController?.selectedIndex = 0
        navigationController?.popViewController(animated: true)
    }
    
    func onTapView()
    {
        view.endEditing(true)
    }
}
