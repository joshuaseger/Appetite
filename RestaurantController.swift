//
//  RestaurantController.swift
//  Appetite1
//
//  Created by Joshua Seger on 3/4/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class RestaurantController: UIViewController {

    let user: PFUser = PFUser.currentUser()
    var numberOfPosts: Int = 0;
    @IBOutlet var restaurantName: UILabel!
    @IBOutlet var numberPostsLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBAction func UpdateButton(sender: AnyObject) {
        self.performSegueWithIdentifier("UpdateRestSegue", sender: nil)
    }
    

    @IBOutlet var ProfilePic: UIImageView!
    @IBAction func PostButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("PostsNavController", sender: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
    
    //Query to find number of Posts a Restaurant user has posted on Appetite.
        var relation = user.relationForKey("PostList")
        relation.query().findObjectsInBackgroundWithBlock{
            (Posts: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                // There was an error
            } else {
                if(Posts != nil){
                self.numberOfPosts = Posts.count;
                self.numberPostsLabel.text = "# of dishes posted: \(self.numberOfPosts)"
                }
                else
                {
                    self.numberPostsLabel.text = "No dishes have been posted at this time!"
                }
            }
        }
        
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationController?.navigationBarHidden = true
        //Code chunk used to retrieve and display a single image from Parse
       
      var imageFile = user["profilePic"] as PFFile!
        if imageFile != nil {
        imageFile.getDataInBackgroundWithBlock{
            (imageData: NSData!, error: NSError!) -> Void in
            if (error == nil){
                let image = UIImage(data: imageData)
                self.ProfilePic.image = image
            }
        }
        }
        
        var name: String! = user["name"] as String!
        var description: String! = user["description"] as String!
     if name != nil
        {
            restaurantName.text = name
        }
        else {
            restaurantName.text = ""
        }
        if description != nil
        {
            descriptionLabel.text = description
        }
        else {
            descriptionLabel.text = ""
        }
    
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
