//
//  PostsListController.swift
//  Appetite1
//  This controller is the data source and delegate for a table view of Restaurant posts
//  Created by Joshua Seger on 3/15/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class PostsListController: UITableViewController{

    @IBOutlet var tableViewPosts: UITableView!
   // internal var index: Int = 0;
    let user = PFUser.currentUser();
    var dishName = [String]();
    var imageFiles = [PFFile]();
    var posts = [PFObject]();
    var numRows: Int = 0
    
    func refresh(){
        self.viewDidLoad()
        self.refreshControl?.endRefreshing()
    }
    
    func refresh(sender:AnyObject)
    {
        self.refresh()
    }
    
    func displayError(title:String, error:String)
    {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in

            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refresh()
    }
    override func viewDidLoad()  {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationController?.navigationBarHidden = false
        var relation = user.relationForKey("PostList")
        relation.query().findObjectsInBackgroundWithBlock {
            (Posts: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                // There was an error
            } else {
                self.posts = [PFObject]()
                self.dishName = [String]()
                self.imageFiles = [PFFile]()
                for post in Posts{
                    self.posts.append(post as PFObject);
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
    
    //Following three methods work together to delete a post with a swipe and tap
    override func tableView(tableViewPosts: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    override func tableView(tableViewPosts: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableViewPosts: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            // Fist must delete post from Parse database, then remove post data from local arrays and reload the table view
            var postToDelete: PFObject = self.posts[indexPath.row]
            postToDelete.deleteInBackgroundWithBlock({(deleted: Bool!, error: NSError!) -> Void in
                if error == nil {
                    self.dishName.removeAtIndex(indexPath.row)
                    self.imageFiles.removeAtIndex(indexPath.row)
                    self.posts.removeAtIndex(indexPath.row)
                    self.displayError("Delete Successful!", error: "The Post was removed from Appetite")
                   self.viewDidLoad()
                }
                else {
                    self.displayError("Delete failed", error: "Failed to connect to Parse database")
                }
            })
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 190
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows
    }

    //Use OOP Principles to manage elements within cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as? PostsTableViewCell
        if ( cell == nil){
            var cell = PostsTableViewCell  (
                style: UITableViewCellStyle.Default, reuseIdentifier: "myCell") as PostsTableViewCell;
            
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
  
            return cell!
    }
}
