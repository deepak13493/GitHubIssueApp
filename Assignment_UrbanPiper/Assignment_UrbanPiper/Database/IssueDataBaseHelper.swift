//
//  IssueDataBaseHelper.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 15/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit
import CoreData

//used to save, retreive, update and delete isse data
struct IssueDataBaseHelper {
    let coreDataStack = CoreDataStack.sharedInstance
    let formatter = DateFormatter()
    
    // replace all issue container class data into actual issue database
    func replaceAll(withnew issueData: [IssueContainer]? ) -> Int {
        // delete all from database
        guard let issueData = issueData else {
            return 0
        }
        removeAllData()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let issues =  issueData.map({
            
            saveIssue($0.title, createdDate: formatter.date(from: $0.createdDate!) as NSDate? , updatedDate:  formatter.date(from: $0.updatedDate!) as NSDate?, deails: $0.details, state: $0.state, comments_url: $0.comments_url)
        })
        self.coreDataStack.saveContext()
        return issues.count
    }
    
    
    func saveIssue(_ title: String?, createdDate: NSDate?, updatedDate: NSDate?, deails: String?, state: String?, comments_url: String?) -> Issue {
        
        let mainContext = self.coreDataStack.getMainContext()
        let issue = Issue(context: mainContext)
        mainContext.perform {
          
            issue.title = title
            issue.createdDate = createdDate
            issue.updatedDate = updatedDate
            issue.details = deails
            issue.state = state
            issue.comments_url = comments_url
        }
        return issue
    }
    
    func getIssues() -> [Issue]? {
        
        var issues: [Issue]?
        let fetchRequest: NSFetchRequest<Issue> = Issue.fetchRequest()
        let sectionSortDescriptor = NSSortDescriptor(key: "updatedDate", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            issues = try coreDataStack.getMainContext().fetch(fetchRequest)
        } catch {
            print("Error with request: \(error)")
        }
        return issues
    }
    

    private func removeAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Issue.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
             try coreDataStack.getMainContext().execute(deleteRequest)
            
        } catch {
            print("Error with request: \(error)")
        }
    }
    
}
