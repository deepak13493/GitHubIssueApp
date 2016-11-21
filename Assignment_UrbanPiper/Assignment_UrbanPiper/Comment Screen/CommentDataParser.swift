//
//  CommentDataParser.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 16/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation

// parse json data and send it database helper
struct CommentDataParser {
    var comments: [CommentContainer]?
    
    mutating func parse(_ forData: Data) -> [CommentContainer]? {
        
        do {
            guard let parsedObjects = try JSONSerialization.jsonObject(with: forData, options: []) as? [[String: AnyObject]] else {
                return nil
            }
            comments =  parsedObjects.map({(parsedObject) -> CommentContainer in
                fillModelClass(parsedObject)
            })
        } catch let error as NSError {
            print(error.description)
        }
        
        return comments
    }
    
    private func fillModelClass(_ forObject: [String: AnyObject]) -> CommentContainer {
        var userName: String?
        
        if let userdetails = (forObject["user"] as? [String: AnyObject]) {
            
            for (key,value) in userdetails {
                if key == "login" {
                    userName = value as? String
                    break
                }
            }
        }
        
        return CommentContainer(userName: userName , createdDate: forObject["created_at"] as? String, updatedDate: forObject["updated_at"] as? String,  details: forObject["body"] as? String)
        
    }
    
}

//used to store issue api data as container which will use for store in database
struct CommentContainer {
    let userName: String?
    let createdDate: String?
    let updatedDate: String?
    let details: String?
}
