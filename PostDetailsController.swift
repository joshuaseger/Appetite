//
//  PostDetailsController.swift
//  Appetite1
//
//  Created by Joshua Seger on 4/4/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class PostDetailsController: UIViewController, UIScrollViewDelegate {


    @IBOutlet var zipLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var restaurantImage: UIImageView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var restaurantNameLabel: UILabel!
    var restaurant: PFObject?


   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var restaurantObject: PFObject = restaurant?.fetchIfNeeded() as PFObject!
        println(restaurantObject)
        restaurantNameLabel.text = restaurantObject["name"] as! String!
        priceLabel.text = restaurantObject["priceGrade"] as? String
        phoneLabel.text = restaurantObject["phone"] as? String
        addressLabel.text = restaurantObject["address"] as? String
        cityLabel.text = restaurantObject["city"] as? String
        stateLabel.text = restaurantObject["state"] as? String
        zipLabel.text = restaurantObject["zip"] as? String

        var imageFile = restaurantObject["profilePic"] as! PFFile!
        if imageFile != nil {
            imageFile.getDataInBackgroundWithBlock{
                (imageData: NSData!, error: NSError!) -> Void in
                if (error == nil){
                    let image = UIImage(data: imageData)
                    self.restaurantImage.image = image
                }
            }
        }
        
        
        
        
        
        //Controller was only passed object reference.  Must fetch actual object from Parse now
        
        // Do any additional setup after loading the view.
    
        scrollView.contentSize = containerView.frame.size;
        
        // Set up the minimum & maximum zoom scale
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        
        centerScrollViewContents()
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = containerView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        containerView.frame = contentsFrame
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return containerView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
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
