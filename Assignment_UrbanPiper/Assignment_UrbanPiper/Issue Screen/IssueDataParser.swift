//
//  IssueDataParser.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 14/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation

// parse json data and send it database helper
struct IssueDataParser {
    var issues: [IssueContainer]?
    
    mutating func parse(_ forData: Data) -> [IssueContainer]? {
        
        do {
            guard let parsedObjects = try JSONSerialization.jsonObject(with: forData, options: []) as? [[String: AnyObject]] else {
                return nil
            }
            issues =  parsedObjects.map({(parsedObject) -> IssueContainer in
                fillModelClass(parsedObject)
            })
        } catch let error as NSError {
            print(error.description)
        }
        
        return issues
    }
    
    private func fillModelClass(_ forObject: [String: AnyObject]) -> IssueContainer {
        return IssueContainer(title: forObject["title"] as? String, createdDate: forObject["created_at"] as? String, updatedDate: forObject["updated_at"] as? String, state: forObject["state"] as? String, details: forObject["body"] as? String, comments_url: forObject["comments_url"] as? String)
        
    }
    
}

//used to store issue api data as container which will use for store in database
struct IssueContainer {
    let title: String?
    let createdDate: String?
    let updatedDate: String?
    let state: String?
    let details: String?
    let comments_url: String?
}
