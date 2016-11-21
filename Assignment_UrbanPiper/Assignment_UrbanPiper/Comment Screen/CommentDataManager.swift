//
//  CommentDataManager.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 16/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation

struct CommentDataManager: CommentRequestResponseHandlerDelegate {
    
    var commentData: (([Comment]?) -> Void)?
    
    let userDefaults = UserDefaults.standard
    
    private var issue: Issue!
    
    //method decide to fetch data from api or cache
    mutating func fetchComment(_ forIssue: Issue, data: @escaping (([Comment]?) -> Void) )  {
        
        self.commentData = data
        self.issue = forIssue
        
        // check if database is empty and need to fetch data from after 24 hours
        if let comments = getAllCachedIssues()
            , let timeStamp = userDefaults.value(forKey: "timeStamp")
            , comments.count > 0
            , (timeStamp as! Date).compare(NSCalendar.current.date(byAdding: .day, value: -1, to: Date())!) == .orderedDescending {
            
            commentData?(comments)
            
        } else {
            var commentRequestResponseHandler = CommentRequestResponseHandler()
            commentRequestResponseHandler.delegate = self
            commentRequestResponseHandler.fetchCommentData(forIssue.comments_url)
        }
        
    }
    
    // get all data after parsing into IssueContainer class
    func getAllCommentsData(_ data: [CommentContainer]?) {
        // save issues data to database
        guard let data = data else {
             commentData?(nil)
            return
        }
        let commentDataHelper = CommentDataBaseHelper()
        let total = commentDataHelper.replaceAll(withnew: data, forIssue: issue)
        print("\(total) comments has been replaced")
        if total > 0 {
            commentData?(getAllCachedIssues()!)
        }
    }
    
    // retreive all issues from database
    func getAllCachedIssues() -> [Comment]? {
        let commentDataHelper = CommentDataBaseHelper()
         return commentDataHelper.getComment(forIssue: issue)

    }
    
    private func updatedComments() -> [Comment]? {
        
        let comment = issue.comments?.allObjects as! [Comment]
         return comment.sorted { (comment1, comment2) -> Bool in
            return comment1.updatedDate?.compare(comment2.updatedDate! as Date) == .orderedAscending
        }
    }
}
