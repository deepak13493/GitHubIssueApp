//
//  IssueRequestResponseHandler.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 14/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation
import UIKit

protocol IssueRequestResponseHandlerDelegate {
    func getAllData(_ data: [IssueContainer]?)
}

struct IssueRequestResponseHandler: APIManagerDelegate {
    
    var apiManager = APIManager()
    var delegate: IssueRequestResponseHandlerDelegate?
    
    mutating func fetchIssueData(_ formUrl: String?)  {
        guard let formUrl = formUrl else {
            return
        }
        apiManager.delegate = self
        apiManager.request(formUrl)
        
    }
    //MARK:- APIManagerDelegate delegate method
    func response(_ data: Data?, error: NSError?) {
        
        guard let data = data else {
            delegate?.getAllData(nil)
            return
        }
        var issueDataParser = IssueDataParser()
        let issueContainerData = issueDataParser.parse(data)
        delegate?.getAllData(issueContainerData)
    }
}
