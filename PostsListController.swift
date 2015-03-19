//
//  PostsListController.swift
//  Appetite1
//
//  Created by Joshua Seger on 3/15/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class PostsListController: UITableViewController {

    var index: Int = 1;
    let user = PFUser.currentUser();
    var List: [AnyObject]! = []
    
    
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
                self.List.append(post)
            
                }
               
            }
                println(self.List);
            //self.dishNamesList changes are bound to this scope
        }

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     return 190
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //Use OOP Principles to manage elements within cell
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as? PostsTableViewCell
        if ( cell == nil){
            var cell = PostsTableViewCell  (
                style: UITableViewCellStyle.Default, reuseIdentifier: "myCell") as PostsTableViewCell
        }
  
       println(" \(List.count) IS CURRENT LIST COUNT")
       println(List)
       cell!.nameOfDish.text = "hello"
        cell!.cellImage.image = UIImage(named: "Food-Icon")
        cell!.sizeToFit()
        index = index + 1
        return cell!
    }

}
