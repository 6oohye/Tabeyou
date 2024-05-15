//
//  LoadingViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/15/24.
//

import UIKit

class LoadingViewCell:UITableViewCell{
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    func start() {
        activityIndicatorView.startAnimating()
    }
}
