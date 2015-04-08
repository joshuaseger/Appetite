//
//  UpdateRestController.swift
//  Appetite1
//
//  Created by Joshua Seger on 3/15/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class UpdateRestController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    @IBOutlet var latitude: UILabel!
    @IBOutlet var longitude: UILabel!
    @IBOutlet var myMap: MKMapView!
    
    var latitudeDegrees:CLLocationDegrees = 0.0
    var longitudeDegrees:CLLocationDegrees = 0.0
    
    @IBOutlet var restEmail: UITextField!
    @IBOutlet var restPhone: UITextField!
    @IBOutlet var restName: UITextField!
    @IBOutlet var dollarSigns: UILabel!
    @IBOutlet var slider: UISlider!
    
    let user: PFUser! = PFUser.currentUser()
    
    @IBAction func descriptionSegue(sender: AnyObject) {
        self.performSegueWithIdentifier("descriptionSegue", sender: nil)
    }
  
    @IBAction func valueChanged(sender: AnyObject) {
        
        var currentValue = slider.value
        if currentValue <= 20.0 {
            dollarSigns.text = "$"
        }
        else if currentValue <= 40.0 {
            dollarSigns.text = "$$"
        }
        else if currentValue <= 60.0 {
            dollarSigns.text = "$$$"
        }
        else if currentValue <= 80.0 {
            dollarSigns.text = "$$$$"
        }
        else if currentValue <= 100.0 {
            dollarSigns.text = "$$$$$"
        }
    }
    
    @IBAction func updateInfo(sender: AnyObject) {
        if (restEmail.text != "" || restPhone.text != "" || restEmail.text != "")
        {
        var user = PFUser.currentUser()
        user["name"] = restName.text
        user["phone"] = restPhone.text
        user["email"] = restEmail.text
        user["priceGrade"] = dollarSigns.text
        user.save()
            displayAlertWithTitle("Great Success!", message: "All fields were saved.")
        }
        else{
            displayAlertWithTitle("Can't Update!", message: "Check your fields.")
        }
        
        
        
    }
    
    @IBAction func CurrentPositionButton(sender: AnyObject) {
    
        PFGeoPoint.geoPointForCurrentLocationInBackground{ (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            
            self.user["location"] = geopoint
            self.user.save()
            
          var newLocation = PFObject(className:"RestaurantLocation")
            newLocation["restaurantLocation"] = geopoint
            newLocation["userPointer"] = PFUser.currentUser()
            newLocation.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    self.displayAlertWithTitle("Great Success!", message: "Your current position has been saved :)")
                    // The object has been saved.
                } else {
                    self.displayAlertWithTitle("Failed to Save", message: "Your current position failed to save")
                }
            }
            }
        
    


    }
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }


   func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    var userLocation:CLLocation = locations[0] as CLLocation
    latitudeDegrees = userLocation.coordinate.latitude
    longitudeDegrees = userLocation.coordinate.longitude
        var latDelta:CLLocationDegrees = 0.01
        var longDelta:CLLocationDegrees = 0.01
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeDegrees, longitudeDegrees)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        myMap.setRegion(region, animated: true)
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Your Position"
        annotation.subtitle = "Does this look right?"
        myMap.addAnnotation(annotation)
       latitude.text = "\(latitudeDegrees)"
        longitude.text = "\(longitudeDegrees)"
    currentLocation = userLocation
    
    

    
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {

        //Print Error
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var user = PFUser.currentUser()
        let name = user["name"] as String!
        if name != nil
        {
            restName.text = name
        }
        
        let phone = user["phone"] as String!
        if phone != nil
        {
            restPhone.text = phone
        }
        
        let email  = user["email"] as String!
        if email != nil
        {
            restEmail.text = email
        }
        
        let price = user["priceGrade"] as String!
        if price != nil{
            
            if price == "$"
            {
            slider.value = 10
            }
            if price == "$$"
            {
                slider.value = 30
            }
            if price == "$$$"
            {
                slider.value = 50
            }
            if price == "$$$$"
            {
                slider.value = 70
            }
            if price == "$$$$$"
            {
                slider.value = 90
            }

            
        }
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTap(sender: UIControl) {
        restEmail.resignFirstResponder()
        restName.resignFirstResponder()
        restPhone.resignFirstResponder()
    }

}
