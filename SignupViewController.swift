//
//  SignupViewController.swift
//  Appetite1
//
//  Created by Joshua Seger on 2/26/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBAction func Back(sender: AnyObject) {
       self.dismissViewControllerAnimated(true, completion: nil)
    }
    func displayAlertWithTitle(title:String,error:String)
    {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func signupRestaurant(sender: AnyObject) {
        
        var error = ""
        
        if username.text == "" || password == "" {
            error = "Please enter a username or password!"}
        
        if (error != "") {
            displayError("Error in Form", error: error)
        }
            
        else
        {
            
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            
            user.signUpInBackgroundWithBlock({(succeeded: Bool, signupError: NSError!) -> Void in
                if signupError == nil {
                    user["role"] = "restaurant"
                    user.save()
                    user = PFUser.currentUser()
                    PFGeoPoint.geoPointForCurrentLocationInBackground{ (geopoint: PFGeoPoint!, error: NSError!) -> Void in
                        
                        user["location"] = geopoint
                        user.save()
                        
                        var newLocation = PFObject(className:"RestaurantLocation")
                        newLocation["restaurantLocation"] = geopoint
                        newLocation["userPointer"] = PFUser.currentUser()
                        newLocation.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError!) -> Void in
                            if (success) {
                                self.displayAlertWithTitle("User Created", error: "You have successfully created a restaurant user.")
                                // The object has been saved.
                            } else {
                               
                            }
                        }
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else{
                    if let errorString = signupError.userInfo?["error"] as? NSString {
                        error = errorString as String;
                    }
                    else{
                        error = "Please try again later."
                    }
                    self.displayError("Could not sign up!", error: error)
                }
            })
            
        }
    }
    
    @IBAction func signupUser(sender: AnyObject) {
        var error = ""
        
        if username.text == "" || password == "" {
            error = "Please enter a username or password!"}
        
        if (error != "") {
            displayError("Error in Form", error: error)
        }
            
        else
        {
            
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            
       
            user.signUpInBackgroundWithBlock({(succeeded: Bool, signupError: NSError!) -> Void in
                if signupError == nil {
                    
                    
                    user["role"] = "diner"
                    user["searchDistance"] = 50.00
                    user.save()
                    self.dismissViewControllerAnimated(true, completion: nil)
        
                    
                }
                else{
                    if let errorString = signupError.userInfo?["error"] as? NSString {
                        error = errorString as String;
                    }
                    else{
                        error = "Please try again later."
                    }
                    self.displayError("Could not sign up!", error: error)
                }
            })
        }
    }
    
    func displayError(title:String,error:String)
    {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
  override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTap(sender: UIControl) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
}
