//
//  DataManager.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 14/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation

private let baseURL = "https://api.github.com/repos/crashlytics/secureudid/issues"

// manage to fetch data from api or cache
struct IssueDataManager: IssueRequestResponseHandlerDelegate {
    
    var issueData: (([Issue]?) -> Void)?
    
    let userDefaults = UserDefaults.standard
    
    //method decide to fetch data from api or cache
    mutating func fetch(_ data: @escaping (([Issue]?) -> Void) )  {
        
        self.issueData = data
        
        // check if database is empty and need to fetch data from after 24 hours
        if let issues = getAllCachedIssues()
            , let timeStamp = userDefaults.value(forKey: "timeStamp")
            , issues.count > 0
            , (timeStamp as! Date).compare(NSCalendar.current.date(byAdding: .day, value: -1, to: Date())!) == .orderedDescending {
            
            issueData?(issues)
            
        } else {
            var issueRequestResponseHandler = IssueRequestResponseHandler()
            issueRequestResponseHandler.delegate = self
            issueRequestResponseHandler.fetchIssueData(baseURL)
        }
        
    }
    
    // get all data after parsing into IssueContainer class
     func getAllData(_ data: [IssueContainer]?) {
        // save issues data to database
        
        guard let data = data else {
            issueData?(nil)
            return
        }
        let issueDataHelper = IssueDataBaseHelper()
        let total = issueDataHelper.replaceAll(withnew: data)
        print("\(total) issue has been replaced")
        userDefaults.set(Date(), forKey: "timeStamp")
        if total > 0 {
         issueData?(issueDataHelper.getIssues() ?? [Issue]())
        }
    }
   
    // retreive all issues from database
     func getAllCachedIssues() -> [Issue]? {
        let issueDataHelper = IssueDataBaseHelper()
         return issueDataHelper.getIssues()
    }
}
