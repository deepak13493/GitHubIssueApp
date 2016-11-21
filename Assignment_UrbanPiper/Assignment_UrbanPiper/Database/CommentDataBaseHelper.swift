//
//  CommentDataBaseHelper.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 16/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation
import CoreData

//used to save, retreive, update and delete isse data
struct CommentDataBaseHelper {
    
    let coreDataStack = CoreDataStack.sharedInstance
    let formatter = DateFormatter()
    
    // replace all issue container class data into actual issue database
    //TODO:- we can also use concurrency for database so it will provide fast insertion
    func replaceAll(withnew commentData: [CommentContainer]?, forIssue issue: Issue ) -> Int {
        // delete all from database
        guard let commentData = commentData else {
            return 0
        }
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let comments =  commentData.map({
            saveComment($0.userName, createdDate: formatter.date(from: $0.createdDate!) as NSDate? , updatedDate:  formatter.date(from: $0.updatedDate!) as NSDate?, deails: $0.details, issue: issue)
        })
        issue.comments = NSSet(array: comments) 
        self.coreDataStack.saveContext()
        return comments.count
        
    }
    
    
    func saveComment(_ userName: String?, createdDate: NSDate?, updatedDate: NSDate?, deails: String?, issue: Issue?) -> Comment {
        
        let mainContext = self.coreDataStack.getMainContext()
        let comment = Comment(context: mainContext)
       
            comment.userName = userName
            comment.createdDate = createdDate
            comment.updatedDate = updatedDate
            comment.details = deails
            comment.issue = issue

        return comment
    }
    
    
    func getComment(forIssue issue: Issue) -> [Comment]? {
        
        var issues: [Comment]?
        let fetchRequest: NSFetchRequest<Comment> = Comment.fetchRequest()
        let sectionSortDescriptor = NSSortDescriptor(key: "updatedDate", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]

        let predicate = NSPredicate(format: "(issue.title CONTAINS  %@)", issue.title!)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            issues = try coreDataStack.getMainContext().fetch(fetchRequest)
        } catch {
            print("Error with request: \(error)")
        }
        return issues
    }
    
    private func removeAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Comment.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coreDataStack.getMainContext().execute(deleteRequest)
            
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    
    
}
