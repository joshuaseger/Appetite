//
//  UserMatchingController.swift
//  Appetite1
//
//  Created by Joshua Seger on 4/1/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class UserMatchingController: UIViewController {

    @IBOutlet var userImage: UIImageView!
    let user = PFUser.currentUser()
    var posts = [PFObject]()
    var dishImages = [NSData]()
    var dishName = [String]()
    var currentDishIndex = 0
    
    var currentLocation: PFGeoPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            var postImage = UIImage(named: "Food-Icon.png")
            self.userImage.image = postImage
            self.userImage.contentMode = UIViewContentMode.ScaleAspectFit
            var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
            self.userImage.addGestureRecognizer(gesture)
            self.userImage.userInteractionEnabled = true
        
    }

        // Do any additional setup after loading the view.
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func wasDragged(gesture: UIPanGestureRecognizer){
        
     
        var hasBeenSwiped: Bool = false
        let translation = gesture.translationInView(self.view)
        var xFromCenter: CGFloat = 0.00
        var label = gesture.view!
        
        xFromCenter += translation.x
        
        var scale = min(50 / abs(xFromCenter), 1)
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
        var rotation: CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 300)
        var stretch: CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        label.transform = stretch
        println(label.center.x)
        
        
        if gesture.state == UIGestureRecognizerState.Ended {
            // 1
            let velocity = gesture.velocityInView(self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 5000
            println("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
            
            // 2
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            // 3
            var finalPoint = CGPoint(x:gesture.view!.center.x + (velocity.x * slideFactor),
                y:gesture.view!.center.y + (velocity.y * slideFactor))
            // 4
            finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
            finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
            
            // 5
            UIView.animateWithDuration(Double(slideFactor * 1),
                delay: 0,
                // 6
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: {gesture.view!.center = finalPoint },
                completion: nil)
            
            if(finalPoint.x > self.view.bounds.width - 5){
                println("Chosen")
                self.currentDishIndex++
                hasBeenSwiped = true
            }
            else if(finalPoint.x < self.view.bounds.width - 370){
                println("Not Chosen")
                self.currentDishIndex++
                hasBeenSwiped = true
            }
            else if self.currentDishIndex < self.dishImages.count  {
                xFromCenter = 0.00
                var scale = min(100 / abs(xFromCenter), 1)
                label.center = CGPoint(x: 0, y: 0 )
                gesture.setTranslation(CGPointZero, inView: self.view)
                var rotation: CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
                var stretch: CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
                label.transform = stretch
                /*label.removeFromSuperview()
                var userImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                userImage.image = UIImage(data: self.dishImages[self.currentDishIndex])
                userImage.contentMode = UIViewContentMode.ScaleAspectFit
                self.view.addSubview(userImage)
                var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                userImage.addGestureRecognizer(gesture)
                userImage.userInteractionEnabled = true
                xFromCenter = 0*/
            }
        }
        if hasBeenSwiped == true {
            if self.currentDishIndex < self.dishImages.count   {
                label.removeFromSuperview()
                var userImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                userImage.image = UIImage(data: self.dishImages[self.currentDishIndex])
                userImage.contentMode = UIViewContentMode.ScaleAspectFit
                self.view.addSubview(userImage)
                var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                userImage.addGestureRecognizer(gesture)
                userImage.userInteractionEnabled = true
                xFromCenter = 0
            } else {
                
                println("No more users")
                
            }
        }
    }

}