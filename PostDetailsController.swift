//
//  PostDetailsController.swift
//  Appetite1
//
//  Created by Joshua Seger on 4/4/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit
import MapKit

class PostDetailsController: UIViewController, MKMapViewDelegate, UIScrollViewDelegate {


    @IBAction func backButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

   
    @IBOutlet var restaurantDescription: UILabel!
    @IBOutlet var userMap: MKMapView!
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
        //Create Map
          userMap.mapType = MKMapType.Satellite
        var restaurantObject: PFObject = restaurant?.fetchIfNeeded() as PFObject!
        var locationPFObject = restaurantObject["location"] as! PFGeoPoint
        var latitude: CLLocationDegrees = locationPFObject.latitude as CLLocationDegrees
        var longitude: CLLocationDegrees = locationPFObject.longitude as CLLocationDegrees
        println("Latitude and Longitude")
        println(latitude)
        println(longitude)
        var latDelta: CLLocationDegrees = 0.1
        var longDelta: CLLocationDegrees = 0.1
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        userMap.setRegion(region, animated: true)
        userMap.mapType = MKMapType.Standard
        //Create Text Labels
        restaurantNameLabel.text = restaurantObject["name"] as! String!
        var price = restaurantObject["priceGrade"] as? String
        var phone = restaurantObject["phone"] as? String
        var address = restaurantObject["address"] as? String
        var city = restaurantObject["city"] as? String
        var state = restaurantObject["state"] as? String
        var zip = restaurantObject["zip"] as? String
        var description = restaurantObject["description"] as? String
        
        restaurantDescription.text = description
        restaurantDescription.textAlignment = NSTextAlignment.Center
        priceLabel.text = "Price Grade: " + price!
        phoneLabel.text = "Phone: " + phone!
        addressLabel.text = "Address: " + address!
        cityLabel.text = "" + city! + ", " + state! + " " + zip!

        
        //Create Image
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
