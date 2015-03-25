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
                for post in Posts{
                    self.numberOfPosts++;
                }
                self.numberPostsLabel.text = "# of dishes posted: \(self.numberOfPosts)"
            }
        }
        
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       

        
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
