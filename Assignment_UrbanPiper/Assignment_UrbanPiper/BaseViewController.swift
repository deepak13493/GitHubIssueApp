//
//  BaseViewController.swift
//  Assignment_UrbanPiper
//
//  Created by Deepak Sharma on 16/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    func showActivityView()  {
        
        activityView.center = CGPoint(x: self.view.frame.size.width / 2.0, y: self.view.frame.size.height / 2.0)
        self.view.isUserInteractionEnabled = false
        activityView.backgroundColor = UIColor.lightGray
        
        DispatchQueue.main.async {[weak self] in
            
        self?.activityView.startAnimating()
        self?.view.addSubview(self!.activityView)
            
        }
    }

    func hideActivityView()  {
        
        DispatchQueue.main.async {[weak self] in
            self?.view.isUserInteractionEnabled = true

            self?.activityView.stopAnimating()
            self?.activityView.removeFromSuperview()
            
        }
    }
}
