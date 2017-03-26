//
//  CaptionViewController.swift
//  belaShare
//
//  Created by daniel on 3/14/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import Parse
import KVNProgress

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
        let hiResImage = image.resized(to: CGSize(width: 1080, height: 1080))
        let lowResImage = image.resized(to: CGSize(width: 64, height: 64))
        let highPFImageFile = getPFFileFrom(image: hiResImage)
        let lowPFImageFile = getPFFileFrom(image: lowResImage)
 
        let post = Post(highResMedia: highPFImageFile, lowResMedia: lowPFImageFile, caption: textView.text, author: PFUser.current())
        
        KVNProgress.show()
        
        post.postToServer
        {
            (success: Bool, error: Error?) in
            
            if error == nil
            {
                KVNProgress.showSuccess(withStatus: "Success")
                {
                    if let navController = self.navigationController, navController.viewControllers.count >= 2
                    {
                        let viewController = navController.viewControllers[navController.viewControllers.count - 2] as! CaptureViewController
                        viewController.imageWasPicked = false
                        viewController.imageView.image = nil
                    }
                    
                    let navC = self.tabBarController?.viewControllers?[0] as! UINavigationController
                    let HomeVC = navC.viewControllers[0] as! HomeViewController
                    HomeVC.onPullToRefresh(nil)
                    self.tabBarController?.selectedIndex = 0
                    let _ = self.navigationController?.popViewController(animated: true)
                    
                }
            }
            else
            {
                KVNProgress.showError()
            }
        }
    }
    
    func onTapView()
    {
        view.endEditing(true)
    }
}
