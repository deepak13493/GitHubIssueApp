//
//  CommentTableViewCell.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 16/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var comments: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
