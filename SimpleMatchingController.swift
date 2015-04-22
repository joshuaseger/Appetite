//
//  SimpleMatchingController.swift
//  Appetite1
//
//  Created by Joshua Seger on 4/7/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//
import Foundation
import UIKit



//TO DO LIST
/*
Fix bugs
Add loading indicator
Pulse when out of dishes to display??? Check libraries
*/
class SimpleMatchingController: UIViewController {
    
    @IBOutlet var indicatorLabel: UILabel!
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
    var imageReference: UIImageView!
    var labelReference: UILabel!
    var noMoreMatches: Bool = false
    

    @IBAction func likeButton(sender: AnyObject) {
        if(noMoreMatches == false) && (currentDishIndex < self.posts.count) {
            currentDishIndex++
            var relation = self.user.relationForKey("PostList")
            var post2Add: PFObject = self.posts[currentDishIndex - 1] as PFObject
            var numMatches: Int! = post2Add["numberMatches"] as! Int
            if (numMatches == nil){
                numMatches = 0;
            }
            numMatches = numMatches + 1
            post2Add["numberMatches"] = numMatches
            post2Add.save()
            relation.addObject(post2Add)
            self.user.save()
            removeImageAndAddNew()
            
            
        }
    }
    
    @IBAction func dislikeButton(sender: AnyObject) {
        if(noMoreMatches == false) && (currentDishIndex < self.posts.count){
            currentDishIndex++
            removeImageAndAddNew()
        }
    }
    
    func removeImageAndAddNew(){
        imageReference.removeFromSuperview()
        labelReference.removeFromSuperview()
     
        if(currentDishIndex <= self.posts.count - 1){
            var newPost = self.posts[currentDishIndex]
            addDraggableImage(newPost)
        }
        else{
            noMorePosts()
        }
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
            if self.posts.count > 0 {
                self.posts = self.shuffle(self.posts)
                currentDishIndex = 0;
                noMoreMatches = false
                addDraggableImage(self.posts[currentDishIndex])
            }
            else{
                  noMorePosts()
                }
        }
    }
    
    
    func noMorePosts(){
        self.noMoreMatches == true
        var image = UIImageView(frame: CGRectMake(self.view.bounds.width / 2 - 125, self.view.bounds.height / 2 - 225, 250, 200))
        var defaultImage = UIImage(named: "DishIcon.png")
        image.image = defaultImage
        self.view.addSubview(image)
        var nameLabel = UILabel()
        nameLabel.frame.size.width = self.view.bounds.width - 20
        nameLabel.frame.size.height = 20
        nameLabel.center.x = self.view.bounds.width / 2
        nameLabel.center.y = self.view.bounds.height / 2 - 10
        nameLabel.bringSubviewToFront(self.view)
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.text = "No more dish posts in your area"
        self.view.addSubview(nameLabel)
        self.labelReference = nameLabel
        self.imageReference = image
        self.imageReference.layer.addPulse{builder in
            builder.borderColors = [UIColor.orangeColor().CGColor]
            builder.backgroundColors = [UIColor.grayColor().CGColor]
            builder.repeatCount = 1000
            builder.duration = NSTimeInterval.abs(2)
    }
    }

    func addDraggableImage(post: PFObject){
        var postImage = UIImageView(frame: CGRectMake(self.view.bounds.width / 2 - 150, self.view.bounds.height / 2 - 265, 300, 300))
        var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        postImage.addGestureRecognizer(gesture)
        postImage.userInteractionEnabled = true
        var imageToAdd = post["imageFile"] as! PFFile;
        imageToAdd.getDataInBackgroundWithBlock{
            (imageData: NSData!, error: NSError!) -> Void in
            if (error == nil){
                postImage.image = UIImage(data: imageData)
            }
            self.view.addSubview(postImage)
            var nameLabel = UILabel(frame: CGRectMake(self.view.bounds.width / 2 - 150, self.view.bounds.height / 2 - 305, 300, 40))
            nameLabel.text = post["DishName"] as! String!
            nameLabel.textAlignment = NSTextAlignment.Center
            self.view.addSubview(nameLabel)
            self.imageReference = postImage
            self.labelReference = nameLabel
        }
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer){
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
        self.indicatorLabel.hidden = true

        if(label.center.x > self.view.bounds.width - 30){
            println("Chosen")
            self.indicatorLabel.hidden = false
            self.view.bringSubviewToFront(self.indicatorLabel)
            self.indicatorLabel.text = "Yummy"
            self.indicatorLabel.textColor = UIColor.whiteColor()
            self.indicatorLabel.backgroundColor = UIColor.greenColor()
        }
        else if(label.center.x < self.view.bounds.width - 330){
            println("Not Chosen")
           self.indicatorLabel.hidden = false
            self.view.bringSubviewToFront(self.indicatorLabel)
            self.indicatorLabel.text = "Not Yummy"
            self.indicatorLabel.backgroundColor = UIColor.redColor()
        }
        
        
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            self.indicatorLabel.hidden = true
            
            if(label.center.x > self.view.bounds.width - 30){
                println("Chosen")
                likeButton(self)
            }
            else if(label.center.x < self.view.bounds.width - 330){
                println("Not Chosen")
                dislikeButton(self)
            }
            xFromCenter = 0.00
            var scale = min(100 / abs(xFromCenter), 1)
            gesture.setTranslation(CGPointZero, inView: self.view)
            var rotation: CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
            var stretch: CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
            label.transform = stretch
            label.center.x = self.view.bounds.width / 2
            label.center.y = self.view.bounds.height / 2 - 115
        }
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.indicatorLabel.hidden = true
    
        if(self.loadedRestaurants == true){
            var distanceStored: Float! = user["searchDistance"] as! Float
            if distanceStored != nil{
                distanceToSearch = Double(distanceStored)
            }
            self.posts = [PFObject]()
            self.restaurants = [PFUser]()
            self.usersMatches = [PFObject]()
            self.loadedUsersMatches  = false
            self.loadedPosts  = false
            self.loadedRestaurants = false
            if(self.labelReference != nil){
                self.labelReference.removeFromSuperview()
                self.imageReference.removeFromSuperview()
            }
            viewDidLoad()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var distanceStored: Float! = user["searchDistance"] as! Float
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
                            self.currentLocation = self.user["location"] as! PFGeoPoint
                            self.prepareForDisplay()
                        }
                        else {
                            println(error)
                            self.currentLocation = self.user["location"] as! PFGeoPoint
                            self.prepareForDisplay()
                        }
                    }
                }
                else
                {
                    //For loop adds posts that user has already been matched with
                    for post in Posts{
                        self.usersMatches.append(post as! PFObject)
                    }
                    
                    self.loadedUsersMatches = true
                    PFGeoPoint.geoPointForCurrentLocationInBackground{ (geopoint: PFGeoPoint!, error: NSError!) -> Void in
                        
                        if error == nil{
                            self.user["location"] = geopoint
                            self.currentLocation = self.user["location"] as! PFGeoPoint
                            self.prepareForDisplay()                      }
                        else {
                            println(error)
                            self.currentLocation = self.user["location"] as! PFGeoPoint
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
        let listCount = count(list)
        for i in 0..<(listCount - 1) {
            let j = Int(arc4random_uniform(UInt32(listCount - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
    
    
    
    //Queries for Restaurants near current users location.
    func findRestaurants(){
        var query = PFQuery(className:"RestaurantLocation")
        query.whereKey("restaurantLocation", nearGeoPoint: self.currentLocation, withinMiles: self.distanceToSearch)
        query.findObjectsInBackgroundWithBlock { (restaurants: [AnyObject]!, error: NSError!) -> Void in
            for restaurant in restaurants
            {
                var  userPointer: PFUser! = restaurant["userPointer"] as! PFUser
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
                            self.posts.append(post as! PFObject)
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




