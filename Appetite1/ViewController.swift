//
//  ViewController.swift
//  Appetite1
//
//  Created by Joshua Seger on 2/26/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
    

    @IBOutlet var password: UITextField!
    @IBOutlet var username: UITextField!
    
    func displayError(title:String,error:String)
    {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func login(sender: AnyObject) {
        
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
            
            user.signUpInBackgroundWithBlock({(succeeded: Bool!, signupError: NSError!) -> Void in
                if signupError == nil {
                    println("Hooray")
                    
                }
                else{
                    if let errorString = signupError.userInfo?["error"] as? NSString {
                        error = errorString;
                    }
                    else{
                        error = "Please try again later."
                    }
                    self.displayError("Could not sign up!", error: error)
                }
            })
            
        }

    }

    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Prints current user to logs for automatic login
        println(PFUser.currentUser())
        
        
        //Background image
        let image1 = UIImage(named: "/Users/joshuaseger/Desktop/Appetite1/Appetite1/Backgrounds/main.jpg")
        let imageview = UIImageView(image: image1)
        imageview.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(imageview)
        self.view.sendSubviewToBack(imageview)
imageview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


