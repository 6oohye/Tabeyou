//
//  HomeRestaurantCollectionViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/11/24.
//

import UIKit

struct HomeRestaurantCollectionViewCellViewModel: Hashable{
    let imageUrl : String
    let title : String
    let station : String
    let time : String
    let price : String
}

final class HomeRestaurantCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var RestaurantItemImageView: UIImageView!
    @IBOutlet weak var RestaurantTitleLabel: UILabel!
    @IBOutlet weak var StationLabel: UILabel!
    @IBOutlet weak var RestaurantTimeLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    
    
    func setViewModel(_ viewModel : HomeRestaurantCollectionViewCellViewModel){
//        RestaurantItemImageView.image =
        RestaurantTitleLabel.text = viewModel.title
        StationLabel.text = viewModel.station
        RestaurantTimeLabel.text = viewModel.time
        PriceLabel.text = viewModel.price
    }
    
}
