//
//  PostsListController.swift
//  Appetite1
//
//  Created by Joshua Seger on 3/15/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class PostsListController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    internal var index: Int = 0;
    let user = PFUser.currentUser();
    internal var PostList: [AnyObject]! = []
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        
        var relation = user.relationForKey("PostList")
        relation.query().findObjectsInBackgroundWithBlock {
            (Posts: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                // There was an error
            } else {
                for post in Posts{
                    //  var dishName: String = post["DishName"] as String
                    self.PostList.append(post)
                    
                }
                
            }
            println("\(self.PostList) Inside the scope");
            //self.dishNamesPostList changes are bound to this scope
        }
        println("\(self.PostList) Outside the scope");
        
        // Do any additional setup after loading the view.
        
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     return 190
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //Use OOP Principles to manage elements within cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as? PostsTableViewCell
        if ( cell == nil){
            var cell = PostsTableViewCell  (
                style: UITableViewCellStyle.Default, reuseIdentifier: "myCell") as PostsTableViewCell
            
        }
        println("\(index) = OUR INDEX")
       println(" \(PostList.count) IS CURRENT PostList COUNT")
       println(PostList)
       cell!.nameOfDish.text = "hello"
        cell!.cellImage.image = UIImage(named: "Food-Icon")
        cell!.sizeToFit()
        index = index + 1
        return cell!
    }

}
