//
//  APIManager.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 14/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import Foundation

protocol APIManagerDelegate {
    func response(_ data: Data?, error: NSError?)
}

struct APIManager {
    var delegate: APIManagerDelegate?
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func request(_ urlString: String) {
        
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        let task = session.dataTask(with: request as URLRequest) { (data: Data?, reponse: URLResponse?, error: Error?) in
            
            if let data = data {
                self.delegate?.response(data as Data?, error: nil)
            } else {
                self.delegate?.response(nil, error: error as NSError?)
            }
            
        }
        task.resume()
        
    }
}
