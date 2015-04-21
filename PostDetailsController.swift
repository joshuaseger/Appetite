//
//  PostDetailsController.swift
//  Appetite1
//
//  Created by Joshua Seger on 4/4/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class PostDetailsController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    var restaurant: PFObject?
    @IBOutlet var restaurantNameLabel: UILabel!

    @IBOutlet var RestaurantImage: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var zipLabel: UILabel!

    override func loadView() {

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var x: PFObject = restaurant?.fetchIfNeeded() as PFObject!
        //Controller was only passed object reference.  Must fetch actual object from Parse now.

        


        
        
        
        

        
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
