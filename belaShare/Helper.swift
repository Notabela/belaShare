//
//  Helper.swift
//  belaShare
//
//  Created by daniel on 3/13/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit
import Parse

//UITextField : override textRect, editingRect
class LeftPaddedTextField: UITextField
{
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
}

func getPFFileFrom(image: UIImage?) -> PFFile?
{
    guard let image = image else {return nil}
    guard let imageData = UIImagePNGRepresentation(image) else {return nil}
    return PFFile(name: "image.png", data: imageData)
}

extension UIImageView
{
    func addDarkBlur()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}

extension UIImage
{
    func resized(to newSize: CGSize) -> UIImage
    {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = self
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}

