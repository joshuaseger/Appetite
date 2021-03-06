//
//  UpdateDescriptionController.swift
//  Appetite1
//
//  Created by Joshua Seger on 3/19/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class UpdateDescriptionController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let user = PFUser.currentUser()
    var photoSelected:Bool = false

    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var descriptionText: UITextView!
    
    @IBAction func backButton(sender: AnyObject) {
        self.performSegueWithIdentifier("back2Update", sender: nil)
    }
    @IBAction func submitDescription(sender: AnyObject) {
        var error = ""
        
        if (descriptionText.text == "")
        {
            error = "Please enter a dish name!"
        }
        
        if (error != "")
        {
            displayError("Error!", error: error)
        }
            
        else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle   = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            user["description"] = descriptionText.text
            user.saveInBackgroundWithBlock{(success:Bool, error: NSError!) -> Void in
                
                if success == false {
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.displayError("Failed to save description", error: "Cannot reach Parse Database")
                    
                }  
                else{
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    println("Successfully saved description to Parse")
                    self.displayError("Great Success!", error: "Your image has been posted successfully and can be viewed in Posts List")
                    self.descriptionText.text = ""
                }
            }
        }
    }
    
    @IBAction func pickImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    @IBAction func setImage(sender: AnyObject) {
        
        var error = ""
        
        if(photoSelected == false){
            error = "Please select an image to post"
        }
        
        if (error != "")
        {
            displayError("Error!", error: error)
        }
            
        else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle   = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
            let imageData = UIImagePNGRepresentation(self.profilePic.image)
            let imageFile = PFFile(name: "image.png", data: imageData)
            user["profilePic"] = imageFile
            
            user.saveInBackgroundWithBlock{(success:Bool, error: NSError!) -> Void in
                
                if success == false {
                    self.displayError("Failed to Post Image", error: "Cannot reach Parse Database")
                }
                else{
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    println("Successfully saved post to Parse")
                    self.displayError("Great Success!", error: "Your image has been posted successfully and can be viewed in Posts List")
                    self.photoSelected = false
                    self.profilePic.image = UIImage(named: "Food-Icon.png")
                    self.descriptionText.text = ""
                
                    
                    
                }
            }
        }
    }
    
    func displayError(title:String,error:String)
    {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.viewDidLoad()
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        profilePic.image = image
        photoSelected = true
        
    }
        
    override func viewDidLoad() {
      
        //Code chunk used to retrieve and display a single image from Parse
        var imageFile = user["profilePic"] as! PFFile!
        if(imageFile != nil)    {
        imageFile.getDataInBackgroundWithBlock{
            (imageData: NSData!, error: NSError!) -> Void in
            if (error == nil){
                if imageData != nil {
                let image = UIImage(data: imageData)
               self.profilePic.image = image
                }}
        }
        }
        
        photoSelected = false
        descriptionText.text = ""
        
        var description = user["description"] as! String!
        if description != nil
        {
            descriptionText.text = description
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTap(sender: UIControl) {
        descriptionText.resignFirstResponder()
    }

}
