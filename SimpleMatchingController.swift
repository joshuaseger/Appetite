//
//  SimpleMatchingController.swift
//  Appetite1
//
//  Created by Joshua Seger on 4/7/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//
import Foundation
import UIKit

class SimpleMatchingController: UIViewController {
    
    @IBOutlet var likedLabel: UILabel!
    let user = PFUser.currentUser()
    var distanceToSearch: Double = 50.00
    var posts = [PFObject]()
    var restaurants = [PFUser]()
    var currentDishIndex = 0
    var usersMatches = [PFObject]()
    var currentLocation: PFGeoPoint!
    var loadedUsersMatches: Bool = false
    var loadedPosts: Bool = false
    var loadedRestaurants: Bool = false
    
    @IBOutlet var dishNameLabel: UILabel!
    
    @IBAction func likeButton(sender: AnyObject) {

        if currentDishIndex <= self.posts.count {
        var relation = self.user.relationForKey("PostList")
        var post2Add: PFObject = self.posts[currentDishIndex - 1] as PFObject
            var numMatches: Int! = post2Add["numberMatches"] as Int!
            if (numMatches == nil){
                numMatches = 0;
            }
            numMatches = numMatches + 1
        post2Add["numberMatches"] = numMatches
        post2Add.save()
        relation.addObject(post2Add)
        self.user.save()
        println(post2Add)
        }
    }
    
    @IBAction func dislikeButton(sender: AnyObject) {
       
    }
    
    func prepareForDisplay(){
        if (self.loadedRestaurants == false && self.loadedUsersMatches == true)
        {
            findRestaurants();
        }
        if (self.loadedRestaurants == true && self.loadedPosts == false){
            findPosts();
        }
        
        if (loadedPosts == true && loadedRestaurants == true){
            if self.posts.count > 0 {self.posts = self.shuffle(self.posts)}
            //self.retrieveNewPost()
            var image = UIImageView(frame: CGRectMake(self.view.bounds.width / 2 - 150, self.view.bounds.height / 2 - 265, 300, 300))
            var imageFiller = UIImage(named: "Food-Icon.png")
            image.image = imageFiller
           view.addSubview(image)
            for post in self.posts {
                var image = UIImageView(frame: CGRectMake(self.view.bounds.width / 2 - 150, self.view.bounds.height / 2 - 265, 300, 300))
                var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                image.addGestureRecognizer(gesture)
                image.userInteractionEnabled = true
                var imageToAdd = post["imageFile"] as PFFile;
                imageToAdd.getDataInBackgroundWithBlock{
                    (imageData: NSData!, error: NSError!) -> Void in
                    if (error == nil){
                        image.image = UIImage(data: imageData)
                    }}
                
                view.addSubview(image)
            }
    
            
    }
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer){

        var hasBeenSwiped: Bool = false
        let translation = gesture.translationInView(self.view)
        var xFromCenter: CGFloat = 0.00
        var label = gesture.view! //Change variable name
        xFromCenter += translation.x
        var scale = min(50 / abs(xFromCenter), 1)
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
        var rotation: CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 300)
        var stretch: CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        label.transform = stretch
        
        println(label.center)
        if(label.center.x > self.view.bounds.width - 10){
            println("Chosen")
            
   
          
        }
        else if(label.center.x < self.view.bounds.width - 350){
            println("Not Chosen")
       
        }
        
        
        
        if gesture.state == UIGestureRecognizerState.Ended {
        
            /*
            let velocity = gesture.velocityInView(self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
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
            UIView.animateWithDuration(Double(slideFactor * 2), delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {gesture.view!.center = finalPoint }, completion: nil)
            */
            
            
          
            if(label.center.x > self.view.bounds.width - 20){
                println("Chosen")
                self.currentDishIndex++
                hasBeenSwiped = true
            }
            else if(label.center.x < self.view.bounds.width - 340){
                println("Not Chosen")
                self.currentDishIndex++
                hasBeenSwiped = true
            }
                xFromCenter = 0.00
                var scale = min(100 / abs(xFromCenter), 1)
                gesture.setTranslation(CGPointZero, inView: self.view)
                var rotation: CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
                var stretch: CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
                label.transform = stretch
                label.center.x = self.view.bounds.width / 2 - 150
                label.center.y = self.view.frame.width
            }
        
    
        if hasBeenSwiped == true {
         
                label.removeFromSuperview()
       
        
        }
    }

  
    override func viewWillAppear(animated: Bool) {

        if(self.loadedRestaurants == true){
            
        
            var distanceStored: Float! = user["SearchDistance"] as Float!
            if distanceStored != nil{
                distanceToSearch = Double(distanceStored)
            }
        self.posts = [PFObject]()
        self.restaurants = [PFUser]()
        self.currentDishIndex = 0
        self.usersMatches = [PFObject]()
        self.loadedUsersMatches  = false
        self.loadedPosts  = false
        self.loadedRestaurants = false
        viewDidLoad()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        likedLabel.hidden = true
        likedLabel.bringSubviewToFront(self.likedLabel)
        
        
        
        var distanceStored: Float! = user["SearchDistance"] as Float!
        if distanceStored != nil{
            distanceToSearch = Double(distanceStored)
        }
        
        var relation = user.relationForKey("PostList")
        if (relation != nil){
            
            relation.query().findObjectsInBackgroundWithBlock {
                (Posts: [AnyObject]!, error: NSError!) -> Void in
                if error != nil {
                    // There was an error
                    self.loadedUsersMatches = true
                    PFGeoPoint.geoPointForCurrentLocationInBackground{ (geopoint: PFGeoPoint!, error: NSError!) -> Void in
                        
                        if error == nil{
                            self.user["location"] = geopoint
                            self.currentLocation = self.user["location"] as PFGeoPoint!
                            self.prepareForDisplay()
                        }
                        else {
                            println(error)
                            self.currentLocation = self.user["location"] as PFGeoPoint!
                            self.prepareForDisplay()
                        }
                    }
                }
                else
                {
                    //For loop adds posts that user has already been matched with
                    for post in Posts{
                        self.usersMatches.append(post as PFObject);
                    }
       
                    self.loadedUsersMatches = true
                    PFGeoPoint.geoPointForCurrentLocationInBackground{ (geopoint: PFGeoPoint!, error: NSError!) -> Void in
                        
                        if error == nil{
                            self.user["location"] = geopoint
                            self.currentLocation = self.user["location"] as PFGeoPoint!
                            self.prepareForDisplay()                      }
                        else {
                            println(error)
                            self.currentLocation = self.user["location"] as PFGeoPoint!
                            self.prepareForDisplay()
                        }
                    }
                    
                }
            }
        }
      }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let count = countElements(list)
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }

 
    /*
    func retrieveNewPost() {
        if currentDishIndex < self.posts.count{
            var postToDisplay = self.posts[self.currentDishIndex]
            var dishName = postToDisplay["DishName"] as String;
            self.dishNameLabel.text = dishName
            var imageToAdd = postToDisplay["imageFile"] as PFFile;
            imageToAdd.getDataInBackgroundWithBlock{
                (imageData: NSData!, error: NSError!) -> Void in
                if (error == nil){
                    self.dishImage.image = UIImage(data: imageData)
                }}
                currentDishIndex++
        }
        else{
            self.dishNameLabel.text = "No more Dish posts available in your area"
            self.dishImage.image = UIImage(named: "Food-Icon.png")
        }
    }
    
*/
    //Queries for Restaurants near current users location.
    func findRestaurants(){
        var query = PFQuery(className:"RestaurantLocation")
        query.whereKey("restaurantLocation", nearGeoPoint: self.currentLocation, withinMiles: self.distanceToSearch)
        query.findObjectsInBackgroundWithBlock { (restaurants: [AnyObject]!, error: NSError!) -> Void in

            for restaurant in restaurants
            {
                var  userPointer: PFUser! = restaurant["userPointer"] as PFUser
              
                self.restaurants.append(userPointer)
                
            }
                self.loadedRestaurants = true
                self.prepareForDisplay()
            }
            
        }
    
    func findPosts(){
        var index = self.restaurants.count
        for restaurant in self.restaurants{
            var relation = restaurant.relationForKey("PostList")
            relation.query().findObjectsInBackgroundWithBlock {
                (Posts: [AnyObject]!, error: NSError!) -> Void in
                if error != nil
                {
                    // There was an error
                }
                else {
                    for post in Posts
                    {
                        var canAdd = true
                        for userPost: PFObject in self.usersMatches{
                            if (userPost.objectId == post.objectId){
                                canAdd = false
                            }
                        }
                        if (canAdd == true){
                            self.posts.append(post as PFObject)
                        }
                    }
                }
                index = index - 1
                if index == 0{
                self.loadedPosts = true
                self.prepareForDisplay()
                }
            }
        }
    }
}

/*
let velocity = gesture.velocityInView(self.view)
let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
let slideMultiplier = magnitude / 500
println("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
var finalPoint = CGPoint(x:gesture.view!.center.x + (velocity.x * slideFactor),
y:gesture.view!.center.y + (velocity.y * slideFactor))
finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
UIView.animateWithDuration(Double(slideFactor * 1), delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {gesture.view!.center = finalPoint }, completion: nil)

*/


