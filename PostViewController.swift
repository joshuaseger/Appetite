//
//  PostViewController.swift
//  Appetite1
//
//  Created by Joshua Seger on 3/16/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var nameOfDish: UITextField!
    @IBOutlet var image2Post: UIImageView!
    var photoSelected:Bool = false
    
    @IBAction func postImageButton(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }

    
    @IBAction func createPost(sender: AnyObject) {
        
         var error = ""
        
        if(photoSelected == false){
             error = "Please select an image to post"
        }
            
        else if (nameOfDish.text == "")
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
            
            
            var post = PFObject(className: "Post")
            post["DishName"] = nameOfDish.text
            post["Restaurant"] = user
            post["numberMatches"] = 0
            post.saveInBackgroundWithBlock{(success:Bool, error: NSError!) -> Void in
                
                if success == false {
                    self.displayError("Failed to Post Image", error: "Cannot reach Parse Database")
                }
                    
                else{
                    let imageData = UIImagePNGRepresentation(self.image2Post.image)
                    let imageFile = PFFile(name: "image.png", data: imageData)
                    post["imageFile"] = imageFile
                    post.saveInBackgroundWithBlock{(success: Bool, error: NSError!) -> Void in
                        
                        if success == false {
                            self.displayError("Failed to Post Image", error: "Cannot reach Parse Database to Post Image")
                        }
                            
                        else{
                            
                          
                            var relation = self.user.relationForKey("PostList")
                            relation.addObject(post)
                            self.user.save()
                            self.activityIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            println("Successfully saved post to Parse")
                            self.displayError("Great Success!", error: "Your image has been posted successfully and can be viewed in Posts List")
                            self.photoSelected = false
                            self.image2Post.image = UIImage(named: "Food-Icon.png")
                            self.nameOfDish.text = ""
                        }
                    }
                }
            
        }
        
    }
}

    

    
   
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let user = PFUser.currentUser()
    
    
    func displayError(title:String,error:String)
    {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
          
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        image2Post.image = image
        photoSelected = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        photoSelected = false
        image2Post.image = UIImage(named: "Food-Icon.png")
        nameOfDish.text = ""
        
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
        nameOfDish.resignFirstResponder()
    }

    /*
    UPDATE AN OBJECT QUERY
    var query = PFQuery(className:"GameScore")
    query.getObjectInBackgroundWithId("xWMyZEGZ") {
    (gameScore: PFObject!, error: NSError!) -> Void in
    if error != nil {
    println(error)
    } else {
    gameScore["cheatMode"] = true
    gameScore["score"] = 1338
    gameScore.saveInBackground()
    }
    }
    */

}
