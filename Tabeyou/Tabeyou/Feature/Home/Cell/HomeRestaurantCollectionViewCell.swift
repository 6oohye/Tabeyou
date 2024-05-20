//
//  HomeRestaurantCollectionViewCell.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/11/24.
//

import UIKit

struct HomeRestaurantCollectionViewCellViewModel: Hashable{
    let id : String
    let imageUrl : String
    let title : String
    let station : String
    let intro : String
    let price : String
}

final class HomeRestaurantCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var RestaurantItemImageView: UIImageView!
    @IBOutlet weak var RestaurantTitleLabel: UILabel!
    @IBOutlet weak var StationLabel: UILabel!
    @IBOutlet weak var RestaurantTimeLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    
    
    func setViewModel(_ viewModel : HomeRestaurantCollectionViewCellViewModel){
        guard let url = URL(string: viewModel.imageUrl) else {
            print("Invalid image URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Failed to load image:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.RestaurantItemImageView.image = image
                }
            } else {
                print("Failed to convert data to image")
            }
        }
        task.resume()
        RestaurantTitleLabel.text = viewModel.title
        StationLabel.text = viewModel.station
        RestaurantTimeLabel.text = viewModel.intro
        PriceLabel.text = viewModel.price
    }
}

extension HomeRestaurantCollectionViewCell{
    static func restaurantListLayout() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(277))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(277))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 0, leading: 14, bottom: 0, trailing: 14)
        section.interGroupSpacing = 10
        
        return section
    }
}
