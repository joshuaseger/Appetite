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
    
    let user = PFUser.currentUser()
    var distanceToSearch: Double = 50.00
    var posts = [PFObject]()
    var restaurants = [PFUser]()
    var currentDishIndex = 0
    var usersMatches = [AnyObject]()
    var currentLocation: PFGeoPoint!
    var loadedUsersMatches: Bool = false
    var loadedPosts: Bool = false
    var loadedRestaurants: Bool = false
    
    @IBOutlet var dishNameLabel: UILabel!
    @IBOutlet var dishImage: UIImageView!
    
    @IBAction func likeButton(sender: AnyObject) {
        retrieveNewPost();
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
        }
    }
    
    @IBAction func dislikeButton(sender: AnyObject) {
        retrieveNewPost()
        println("Post was not liked")
    }
    
  
    
    override func viewWillAppear(animated: Bool) {
        println("View Will Appear Called")
       if (self.loadedRestaurants == false && self.loadedUsersMatches == true)
       {
        findRestaurants();
        }
        if (self.loadedRestaurants == true && self.loadedPosts == false){
            findPosts();
        }
        
        if (loadedPosts == true && loadedRestaurants == true){
            println(self.posts)
        self.posts = self.shuffle(self.posts)
        self.retrieveNewPost()
    
        }
       
 
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var distanceStored: Float! = user["SearchDistance"] as Float!
        println(distanceStored)
        if distanceStored != nil{
            distanceToSearch = Double(distanceStored)
            println("DISTANCE TO Search")
            println(distanceToSearch)
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
                            self.viewWillAppear(true)
                        }
                        else {
                            println(error)
                            self.currentLocation = self.user["location"] as PFGeoPoint!
                            self.viewWillAppear(true)
                        }
                    }
                }
                else
                {
                    //For loop adds posts that user has already been matched with
                    for post in Posts{
                        self.usersMatches.append(post as AnyObject);
                    }
       
                    self.loadedUsersMatches = true
                    PFGeoPoint.geoPointForCurrentLocationInBackground{ (geopoint: PFGeoPoint!, error: NSError!) -> Void in
                        
                        if error == nil{
                            self.user["location"] = geopoint
                            self.currentLocation = self.user["location"] as PFGeoPoint!
                            self.viewWillAppear(true)                        }
                        else {
                            println(error)
                            self.currentLocation = self.user["location"] as PFGeoPoint!
                            self.viewWillAppear(true)
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
    

    */
    func retrieveNewPost() {
        println("Called Retrieve New Post with Index of :")
        println(currentDishIndex)
        println(self.posts.count)
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
    
    //Queries for Restaurants near current users location.
    func findRestaurants(){
        println("Searching by Distance offfffffffff")
        println(self.distanceToSearch)
        var query = PFQuery(className:"RestaurantLocation")

        query.whereKey("restaurantLocation", nearGeoPoint: self.currentLocation, withinMiles: self.distanceToSearch)
        query.findObjectsInBackgroundWithBlock { (restaurants: [AnyObject]!, error: NSError!) -> Void in

            for restaurant in restaurants
            {
                var  userPointer: PFUser! = restaurant["userPointer"] as PFUser
                self.restaurants.append(userPointer)
            }
                self.loadedRestaurants = true
                self.viewWillAppear(true)
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
                        self.posts.append(post as PFObject)
                    }
                }
                index = index - 1
                if index == 0{
                self.loadedPosts = true
                self.viewWillAppear(true)
                    
                }
               
            }
            
        }
        
    }
}




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


