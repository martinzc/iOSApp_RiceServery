//
//  MenuDetailViewController.swift
//  riceServeryApp
//
//  Created by Martin Zhou on 11/28/16.
//  Copyright © 2016 Martin Zhou. All rights reserved.
//

import UIKit
import Social

class MenuDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    var loadedImage:UIImage?
    var inDish: String = ""
    
    @IBAction func commentBtn(sender: AnyObject) {
        textField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dishName.text = inDish
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (loadedImage != nil) {
            photoView.image = loadedImage
        }
    }

    @IBAction func selectImageFromLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .PhotoLibrary
        
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        photoView.image = selectedImage
        
        performSegueWithIdentifier("editImageSegue", sender: self)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showShareOptions(sender: AnyObject) {
        // Dismiss the keyboard if it's visible.
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
        
        let actionSheet = UIAlertController(title: "", message: "Share your Comment", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // Configure a new action for sharing the note in Twitter.
        let tweetAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                if self.textField.text!.characters.count <= 140 {
                    twitterComposeVC.setInitialText("\(self.textField.text!)")
                }
                else {
                    let index = self.textField.text!.startIndex.advancedBy(140)
                    let subText = self.textField.text!.substringToIndex(index)
                    twitterComposeVC.setInitialText("\(subText)")
                }
                
                self.presentViewController(twitterComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not logged in to your Twitter account.")
            }
            
            
        }
        
        
        // Configure a new action to share on Facebook.
        let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                facebookComposeVC.setInitialText("\(self.textField.text!)")
                
                self.presentViewController(facebookComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not connected to your Facebook account.")
            }
            
        }
        
        // Configure a new action to show the UIActivityViewController
        let moreAction = UIAlertAction(title: "More", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let activityViewController = UIActivityViewController(activityItems: [self.textField.text!], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [UIActivityTypeMail]
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
        }
        
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(facebookPostAction)
        actionSheet.addAction(moreAction)
        actionSheet.addAction(dismissAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "RiceServery", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editImageSegue" {
            let destination = segue.destinationViewController as! EditImageViewController
            destination.loadedImage = photoView.image
        }
    }
    
}
