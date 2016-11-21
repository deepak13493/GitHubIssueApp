//
//  ViewController.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 14/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit

class IssueViewController: BaseViewController {
    
    var issues: [Issue]?
    var issueDataManager = IssueDataManager()
    
    @IBOutlet weak var issueTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadData() {
        showActivityView()
        issueDataManager.fetch { [weak self](issues) in
            DispatchQueue.main.async {
                if let issues = issues {
                    self?.issues = issues
                    self?.issueTableView.reloadData()

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

extension IssueViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let issueTableViewCell =  tableView.dequeueReusableCell(withIdentifier: String(describing: IssueTableViewCell.self), for: indexPath) as! IssueTableViewCell
       issueTableViewCell.configureCell(issues?[indexPath.row].title, details: issues?[indexPath.row].details)
        
        return issueTableViewCell
    }
    
   
}

extension IssueViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commentViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: CommentViewController.self)) as! CommentViewController
        commentViewController.issue = issues?[indexPath.row]
        navigationController?.pushViewController(commentViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)

    }
}
