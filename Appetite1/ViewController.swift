//
//  ViewController.swift
//  Appetite1
//
//  Created by Joshua Seger on 2/26/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
 /* These fields and methods will help provide for automatic login using iOS keychain
    
    let service = "swiftLogin"
    let userAccount = "swiftLoginUser"
    let key = "RandomKey"
  
    override func viewDidAppear(animated: Bool) {
        let (dictionary, error) = Locksmith.loadData(forKey: key, inService: service, forUserAccount: userAccount)
        
        if let dictionary = dictionary {
            // User is already logged in, Send them to already logged in view.
        } else {
            // Not logged in, send to login view controller
        }
    }
   */

    @IBOutlet var password: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var backgroundView: UIImageView!
    
    func displayError(title:String, error:String)
    {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
           // self.dismissViewControllerAnimated(true, completion: nil)
            
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
            
        else {
            
            PFUser.logInWithUsernameInBackground(username.text, password: password.text) {
                (user: PFUser!, loginError: NSError!) -> Void in
                if loginError == nil {
         
                    if (PFUser.currentUser() != nil) {
                        
                      var role: AnyObject! = PFUser.currentUser().objectForKey("role")
                        if role as! NSString == "diner" {
                            println("called segue to diner")
                            
                        self.performSegueWithIdentifier("DinerPostsSegue", sender: nil)
                        }
                        else {
                            self.performSegueWithIdentifier("RestaurantLoginSegue", sender: nil)
                            
                        }
                    }
                                    } else {
                    var loginError = "Please try again or signup"
                    self.displayError("Login Failed", error: loginError)
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        //Prints current user to logs for automatic login
        println(PFUser.currentUser())
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTap(sender: UIControl) {
       password.resignFirstResponder()
        username.resignFirstResponder()
    }
    
}


