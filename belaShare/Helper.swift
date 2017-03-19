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

//Minutes ago, years ago extension
extension DateFormatter
{
    /**
     Formats a date as the time since that date (e.g., “Last week, yesterday, etc.”).
     
     - Parameter from: The date to process.
     - Parameter numericDates: Determines if we should return a numeric variant, e.g. "1 month ago" vs. "Last month".
     
     - Returns: A string with formatted `date`.
     */
    class func timeSince(from: Date) -> String {
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now as Date
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
        
        var result = ""
        
        if components.year! >= 1 {
            result = "\(components.year!)y"
        } else if components.month! >= 1 {
            result = "\(components.month!)m"
        } else if components.weekOfYear! >= 1 {
            result = "\(components.weekOfYear!)w"
        } else if components.day! >= 1 {
            result = "\(components.day!)d"
        } else if components.hour! >= 1 {
            result = "\(components.hour!)h"
        } else if components.minute! >= 1 {
            result = "\(components.minute!)m"
        } else if components.second! >= 1 {
            result = "\(components.second!)s"
        } else {
            result = "Just now"
        }
        
        return result
    }
    
    /*
     * Example Usage
     */
    /*
     var time = "2016-07-17 12:35:22 GMT"
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'GMT'"
     let date = dateFormatter.date(from: time)!
     var timeStamp: String = dateFormatter.timeSince(from: date, numericDates: true)
     */
}

extension Int
{
    
    //usage
    //let me = 50000.abbreviated
    
    var abbreviated: String
    {
        let abbrev = "KMBTPE"
        return abbrev.characters.enumerated().reversed().reduce(nil as String?) { accum, tuple in
            let factor = Double(self) / pow(10, Double(tuple.0 + 1) * 3)
            let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
            return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
            } ?? String(self)
    }
}

extension UIViewController
{    
    func showMessage(title: String, message: String)
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) -> Void in /*Some Code to Execute*/}
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
}
