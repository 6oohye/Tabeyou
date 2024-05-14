//
//  HomeButtonCollectionViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/10/24.
//

import UIKit

struct HomeButtonCollectionViewCellViewModel : Hashable{
    let buttonImage : UIButton.ButtonType
}

class HomeButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var button300m: UIButton!
    @IBOutlet weak var button500m: UIButton!
    @IBOutlet weak var button1km: UIButton!
    @IBOutlet weak var button3km: UIButton!
    
    var rangeButtonTapped: ((RangeButton) -> Void)?
        
        @IBAction func buttonTapped(_ sender: UIButton) {
            var range: RangeButton?
            switch sender {
            case button300m:
                range = ._300m
            case button500m:
                range = ._500m
            case button1km:
                range = ._1km
            case button3km:
                range = ._3km
            default:
                break
            }
            if let range = range {
                rangeButtonTapped?(range)
            }
        }
    
    
    func setViewModel(_ viewModel : HomeButtonCollectionViewCellViewModel){
        button300m.setImage(UIImage(named: "Button300m"), for: .normal)
        button500m.setImage(UIImage(named: "Button500m"), for: .normal)
        button1km.setImage(UIImage(named: "Button1km"), for: .normal)
        button3km.setImage(UIImage(named: "Button3km"), for: .normal)
        
    }
}

extension HomeButtonCollectionViewCell{
    static func buttonLayout() -> NSCollectionLayoutSection{
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 0, bottom: 20, trailing: 0)
        return section
    }
}
