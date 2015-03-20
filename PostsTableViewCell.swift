//
//  PostsTableViewCell.swift
//  Appetite1
//
//  Created by Joshua Seger on 3/16/15.
//  Copyright (c) 2015 JoshuaSeger. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var nameOfDish: UILabel!

    
    
    override func awakeFromNib() {

        super.awakeFromNib()

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
