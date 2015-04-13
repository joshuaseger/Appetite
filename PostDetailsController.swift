//
//  PostDetailsController.swift
//  Appetite1
//
//  Created by Joshua Seger on 4/4/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class PostDetailsController: UITableViewController {

    var restaurant: PFObject?
    
    @IBAction func backButton(sender: AnyObject) {
        
         self.navigationController?.navigationBarHidden = true
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var RestaurantImage: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var profilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
         self.navigationController?.navigationBarHidden = false
        //Controller was only passed object reference.  Must fetch actual object from Parse now.
        
        var x: PFObject =  restaurant?.fetchIfNeeded() as PFObject!
        
        restaurantNameLabel.text = x["name"] as? String
        priceLabel.text = x["priceGrade"] as? String
        emailLabel.text = x["email"]  as? String
        phoneLabel.text = x["phone"] as? String
        descriptionLabel.text = x["description"] as? String
        var imageFile = x["profilePic"] as PFFile
        imageFile.getDataInBackgroundWithBlock{
            (imageData: NSData!, error: NSError!) -> Void in
            if (error == nil){
                let image = UIImage(data: imageData)
                self.profilePic.image = image;
            }
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
