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
    @IBOutlet var address: UITextField!
    @IBOutlet var city: UITextField!
    @IBOutlet var state: UITextField!
    @IBOutlet var zip: UITextField!
    
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
        if (restEmail.text != "" || restPhone.text != "" || restEmail.text != "" || address.text != "" || city.text != "" || state.text != "" || zip.text != "")
        {
        var user = PFUser.currentUser()
        user["name"] = restName.text
        user["phone"] = restPhone.text
        user["email"] = restEmail.text
        user["priceGrade"] = dollarSigns.text
        user["address"] = address.text
        user["city"] = city.text
        user["state"] = state.text
        user["zip"] = zip.text
        user.save()
            displayAlertWithTitle("Great Success!", message: "All fields were saved.")
        }
        else{
            displayAlertWithTitle("Can't Update!", message: "Check your fields.")
        }
    }
    
    @IBAction func CurrentPositionButton(sender: AnyObject) {
        
       var userPointerQuery = PFQuery(className: "RestaurantLocation")
        userPointerQuery.whereKey("userPointer", equalTo: user)
        var restaurant:PFObject = userPointerQuery.getFirstObject()
        println(restaurant)
        
    
        PFGeoPoint.geoPointForCurrentLocationInBackground{ (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            
            self.user["location"] = geopoint
            self.user.save()
            restaurant["restaurantLocation"] = geopoint
            restaurant.save()
            self.displayAlertWithTitle("Location Saved", message: "Your current location has been set successfully")
        
    
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
    var userLocation:CLLocation = locations[0] as! CLLocation
    latitudeDegrees = userLocation.coordinate.latitude
    longitudeDegrees = userLocation.coordinate.longitude
    latitude.text = "\(latitudeDegrees)"
    longitude.text = "\(longitudeDegrees)"
    currentLocation = userLocation
    
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {

      
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var user = PFUser.currentUser()
        let name = user["name"] as! String!
        if name != nil
        {
            restName.text = name
        }
      
        
        let phone = user["phone"] as! String!
        if phone != nil
        {
            restPhone.text = phone
        }
        
        let email  = user["email"] as! String!
        if email != nil
        {
            restEmail.text = email
        }
        
        let address1 = user["address"] as! String!
        if address1 != nil
        {
            address.text = address1
        }
        
        let city1 = user["city"] as! String!
        if city1 != nil
        {
            city.text = city1
        }
        
        let state1 = user["state"] as! String!
        if state1 != nil
        {
            state.text = state1
        }
        
        let zip1 = user["zip"] as! String!
        if zip != nil
        {
            zip.text = zip1
        }

        
        let price = user["priceGrade"] as! String!
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
