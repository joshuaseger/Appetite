//
//  UserSettingsController.swift
//  Appetite1
//
//  Created by Joshua Seger on 4/7/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class UserSettingsController: UIViewController {

    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var distanceSlider: UISlider!
    
    @IBAction func sliderChanged(sender: AnyObject) {
        var currentValue = distanceSlider.value
        var value = String(format: "%0.f", currentValue)
        distanceLabel.text = "Search Distance: \(value) Miles"
    }
    @IBOutlet var priceRangeSelector: UISegmentedControl!
    @IBAction func changedPriceRange(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        distanceSlider.minimumValue = 1
        distanceSlider.maximumValue = 100
        distanceSlider.value = 50
        distanceLabel.text = "Search Distance: 50 Miles"

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
