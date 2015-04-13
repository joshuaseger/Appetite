//
//  PostDetailsController.swift
//  Appetite1
//
//  Created by Joshua Seger on 4/4/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class PostDetailsController: UIViewController{

    @IBOutlet var scrollView: UIScrollView!
    var restaurant: PFObject?
    
    @IBAction func backButton(sender: AnyObject) {
        
         self.navigationController?.navigationBarHidden = true
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        let center = width/2
        
        var x: PFObject = restaurant?.fetchIfNeeded() as PFObject!
         self.navigationController?.navigationBarHidden = false
        //Controller was only passed object reference.  Must fetch actual object from Parse now.
        
        let restaurantName: UILabel = UILabel(frame: CGRectMake(center, 15, 120, 50))
        restaurantName.layer.borderColor = UIColor.redColor().CGColor
        restaurantName.layer.borderWidth = 3.0
        restaurantName.textAlignment = NSTextAlignment.Center
       restaurantName.text = x["name"] as String!
        scrollView.contentSize = CGSize(width: 350, height: 2500)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.addSubview(restaurantName)
    
   
     
       
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
