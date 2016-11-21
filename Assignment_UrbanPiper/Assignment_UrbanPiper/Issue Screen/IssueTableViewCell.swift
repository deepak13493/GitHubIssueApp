//
//  IssueTableViewCell.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 15/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit

let characterLimit = 140
class IssueTableViewCell: UITableViewCell {

    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var title: UILabel!
  
    func configureCell(_ title: String?, details: String?) {
        
        if let details = details {
        //need to check better logic for this
        let suffix = details.characters.count > characterLimit ? "..." : ""
        self.details.text = details.substring(to: details.index(details.startIndex, offsetBy: characterLimit)) + suffix
        }
        self.title.text = title
    }
}
