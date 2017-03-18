//
//  CaptureViewController.swift
//  belaShare
//
//  Created by daniel on 3/13/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit

class CaptureViewController: UIViewController, UIScrollViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageWasPicked = false
    
    var image: UIImage!
    {
        didSet
        {
            imageView.image = image
            imageWasPicked = true
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if (!imageWasPicked) { showPickerView() }
    }
    
    func showPickerView()
    {
        let actionSheet = UIAlertController(title: "New Post", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default) { action in self.showCamera() })
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default)  { action in self.showAlbum()  })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel)  { action in self.returnToHomeView()})
        actionSheet.modalPresentationStyle = .popover
        actionSheet.preferredContentSize = CGSize(width: 50, height: 50)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.image = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
           self.image = image
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
    
    //showAlbum
    func showAlbum()
    {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func returnToHomeView()
    {
        tabBarController?.selectedIndex = 0
    }
    

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView)
    {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        self.scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! CaptionViewController
        vc.image = image
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem)
    {
        imageWasPicked = false
        returnToHomeView()
    }
    

}
