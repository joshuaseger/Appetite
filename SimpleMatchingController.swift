//
//  SimpleMatchingController.swift
//  Appetite1
//
//  Created by Joshua Seger on 4/3/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//
import Foundation
import UIKit

class SimpleMatchingController: UIViewController {

    @IBOutlet var dishNameLabel: UILabel!
    @IBOutlet var dishImage: UIImageView!
    @IBAction func likeButton(sender: AnyObject) {
        retrieveNewPost();
        println("Post was liked!")
        if currentDishIndex < self.posts.count {
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
    
    let user = PFUser.currentUser()
    var posts = [PFObject]()
    var currentDishIndex = 0
    
    var currentLocation: PFGeoPoint!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        currentLocation = user["location"] as PFGeoPoint!
        var query = PFQuery(className:"RestaurantLocation")
        query.whereKey("restaurantLocation", nearGeoPoint: currentLocation, withinMiles: 100.00)
        
        query.findObjectsInBackgroundWithBlock {
            (restaurants: [AnyObject]!, error: NSError!) -> Void in
            for restaurant in restaurants{
                var  matchedUser: PFUser! = restaurant["userPointer"] as PFUser
                var relation = matchedUser.relationForKey("PostList")
                relation.query().findObjectsInBackgroundWithBlock {
                    (Posts: [AnyObject]!, error: NSError!) -> Void in
                    if error != nil {
                        // There was an error
                    } else {
                        println(Posts)
                        for post in Posts{
                            
                            //STILL NEED TO CHECK AGAINST POSTLIST to make sure user hasn't already matched a post!
                            
                            
                            
                            self.posts.append(post as PFObject);
                            println("All posts added!")
                        }}
                 self.posts = self.shuffle(self.posts)
                    self.retrieveNewPost()
                }}
           
        }
        // Do any additional setup after loading the view.
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

    func retrieveNewPost() {
     
        if currentDishIndex < self.posts.count{
            var postToDisplay = self.posts[self.currentDishIndex]
            var dishName = (postToDisplay["DishName"] as String);
            self.dishNameLabel.text = dishName
            var imageToAdd = postToDisplay["imageFile"] as PFFile;
            imageToAdd.getDataInBackgroundWithBlock{
                (imageData: NSData!, error: NSError!) -> Void in
                if (error == nil){
                    self.dishImage.image = UIImage(data: imageData)
                    println("Image added!")
                }}
        currentDishIndex++
        }
        else{
            self.dishNameLabel.text = "No more Dish posts available in your area"
            self.dishImage.image = UIImage(named: "Food-Icon.png")
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


