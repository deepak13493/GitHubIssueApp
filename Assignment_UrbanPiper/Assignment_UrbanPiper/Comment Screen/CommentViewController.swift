//
//  CommentViewController.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 16/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit

class CommentViewController: BaseViewController {

    var comments: [Comment]?
    var commentDataManager = CommentDataManager()
    var issue: Issue!
    
    @IBOutlet weak var commentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData() {
        showActivityView()
        commentDataManager.fetchComment(issue) { [weak self](comments) in
            DispatchQueue.main.async {
                if let comments = comments {
                    self?.comments = comments
                    self?.commentTableView.reloadData()
                    
                } else {
                    let alert = UIAlertController(title: "Alert", message: "Please check your Network, If it is ok", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                        self?.loadData()
                        
                    }))
                    self?.present(alert, animated: true, completion: nil)
                }
                self?.hideActivityView()
            }
        }
    }
}


extension CommentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let commentTableViewCell =  tableView.dequeueReusableCell(withIdentifier: String(describing: CommentTableViewCell.self), for: indexPath) as! CommentTableViewCell
        
        commentTableViewCell.comments.text = comments?[indexPath.section].details
    
        return commentTableViewCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return comments?[section].userName?.capitalizingFirstLetter()
    }
}

extension CommentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
