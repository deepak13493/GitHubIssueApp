//
//  CommentRequestResponseHandler.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 16/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation

protocol CommentRequestResponseHandlerDelegate {
    func getAllCommentsData(_ data: [CommentContainer]?)
}

struct CommentRequestResponseHandler: APIManagerDelegate {
    
    var apiManager = APIManager()
    var delegate: CommentRequestResponseHandlerDelegate?
    
    mutating func fetchCommentData(_ formUrl: String?)  {
        guard let formUrl = formUrl else {
            return
        }
        apiManager.delegate = self
        apiManager.request(formUrl)
        
    }
    //MARK:- APIManagerDelegate delegate method
    func response(_ data: Data?, error: NSError?) {
        guard let data = data else {
            delegate?.getAllCommentsData(nil)
            return
        }
        var commentDataParser = CommentDataParser()
        let commentContainerData = commentDataParser.parse(data)
        delegate?.getAllCommentsData(commentContainerData)
    }
}
