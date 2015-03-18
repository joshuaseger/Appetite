//
//  PostsListController.swift
//  Appetite1
//
//  Created by Joshua Seger on 3/15/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class PostsListController: UITableViewController {

    
    var posts = [AnyObject]()
    var images = [UIImage]()
    var dishNames = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
      //  cell!.cellImage = UIImageView()
      //  cell!.nameOfDish = UILabel()
        cell!.cellImage.image = UIImage(named: "Food-Icon")
        cell!.nameOfDish.text = "General Tso's Chicken"
        cell!.sizeToFit()
        return cell!
    }

}
