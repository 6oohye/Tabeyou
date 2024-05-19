//
//  BookmarkTableViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/20/24.
//

import UIKit

import Foundation

struct BookmarkTableViewCellViewModel {
    let imageUrl: String
    let title: String
    let station: String
    let price: String
    let access: String
  
}


class BookmarkTableViewCell: UITableViewCell {

    static let identifier = "BookmarkTableViewCell"
    static let height : CGFloat = 100
       
       @IBOutlet weak var restaurantImageView: UIImageView!
       @IBOutlet weak var restaurantNameLabel: UILabel!
       @IBOutlet weak var stationLabel: UILabel!
       @IBOutlet weak var priceLabel: UILabel!
       @IBOutlet weak var locationLabel: UILabel!
       
    func configure(with viewModel: BookmarkTableViewCellViewModel) {
        restaurantImageView.kf.setImage(with: URL(string: viewModel.imageUrl))
        restaurantNameLabel.text = viewModel.title
        stationLabel.text = viewModel.station
        priceLabel.text = viewModel.price
        locationLabel.text = viewModel.access
    }
    
}
