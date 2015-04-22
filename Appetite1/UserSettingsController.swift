//
//  UserSettingsController.swift
//  Appetite1
//
//  Created by Joshua Seger on 4/7/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class UserSettingsController: UIViewController {

    let user = PFUser.currentUser()
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var distanceSlider: UISlider!
    var valueToStore: NSNumber! = 50.00
    
    @IBAction func sliderChanged(sender: AnyObject) {
        var currentValue = distanceSlider.value
        var value = String(format: "%0.f", currentValue)
        distanceLabel.text = "Search Distance: \(value) Miles"
        valueToStore = NSNumber(float: currentValue)
       
        
    }
    @IBAction func Logout(sender: AnyObject) {
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task 
            self.viewWillDisappear(true)
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI 
            PFUser.logOut()
        self.performSegueWithIdentifier("LogoutUserSegue", sender: nil)
            }
        }
       
       
        
    }
    @IBOutlet var priceRangeSelector: UISegmentedControl!
    @IBAction func changedPriceRange(sender: AnyObject) { }
    
    
    override func viewWillDisappear(animated: Bool) {
        println("Search Distance Stored")
        user["searchDistance"] = valueToStore
        user.save()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        distanceSlider.minimumValue = 1
        distanceSlider.maximumValue = 100
        
        var storedValue = user["searchDistance"] as! Float!
        if (storedValue == nil){
            distanceSlider.value = 50
        }
        else{
            distanceSlider.value = storedValue
        }
        var currentValue = distanceSlider.value
        var value = String(format: "%0.f", currentValue)
        distanceLabel.text = "Search Distance: \(value) Miles"

        priceRangeSelector.selectedSegmentIndex = 0
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
