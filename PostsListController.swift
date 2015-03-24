//
//  PostsListController.swift
//  Appetite1
//
//  Created by Joshua Seger on 3/15/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class PostsListController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableViewPosts: UITableView!
   // internal var index: Int = 0;
    let user = PFUser.currentUser();
    var dishName = [String]();
    var imageFiles = [PFFile]();
    var numRows: Int = 0
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        
        var relation = user.relationForKey("PostList")
        relation.query().findObjectsInBackgroundWithBlock {
            (Posts: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                // There was an error
            } else {
                for post in Posts{
                    self.dishName.append(post["DishName"] as String);
                    self.imageFiles.append(post["imageFile"] as PFFile);
                }
                
            }
     
            self.numRows = Posts.count
            self.tableViewPosts.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
        
    
        
 
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
  
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows
    }
    
    //Use OOP Principles to manage elements within cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as? PostsTableViewCell
        if ( cell == nil){
            var cell = PostsTableViewCell  (
                style: UITableViewCellStyle.Default, reuseIdentifier: "myCell") as PostsTableViewCell
            
        }
       
       
     println(indexPath)
 
       cell!.nameOfDish.text = dishName[indexPath.row]
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock{
            (imageData: NSData!, error: NSError!) -> Void in
            if (error == nil){
         let image = UIImage(data: imageData)
                cell!.cellImage.image = image;
            }
        }
        cell!.sizeToFit()

            return cell!
    }

}
