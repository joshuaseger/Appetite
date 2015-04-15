//
//  PostDetailsController.swift
//  Appetite1
//
//  Created by Joshua Seger on 4/4/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class PostDetailsController: UIViewController{

    var restaurant: PFObject?
    let scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
    let mainContent = UIView()

    override func loadView() {
        self.view = self.scrollView
        self.scrollView.contentSize = CGSize (width: self.view.bounds.width, height: self.view.bounds.height * 2)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var x: PFObject = restaurant?.fetchIfNeeded() as PFObject!
        //Controller was only passed object reference.  Must fetch actual object from Parse now.
         self.navigationController?.navigationBarHidden = true
        
        self.view.addSubview(mainContent)
        
        self.scrollView.contentOffset = CGPoint(x: 10, y: 20)
        
        
        
        

        
        // Do any additional setup after loading the view.
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
