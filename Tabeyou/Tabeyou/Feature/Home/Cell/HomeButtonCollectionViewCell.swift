//
//  HomeButtonCollectionViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/10/24.
//

import UIKit

struct HomeButtonCollectionViewCellViewModel : Hashable{
    let buttonImage : UIButton.ButtonType
    let range: Int
}

class HomeButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var button300m: UIButton!
    @IBOutlet weak var button500m: UIButton!
    @IBOutlet weak var button1km: UIButton!
    @IBOutlet weak var button3km: UIButton!
    
    
    func setViewModel(_ viewModel : HomeButtonCollectionViewCellViewModel){
        switch viewModel.range {
           case 1:
               button300m.setImage(UIImage(named: "Button300m"), for: .normal)
           case 2:
               button500m.setImage(UIImage(named: "Button500m"), for: .normal)
           case 3:
               button1km.setImage(UIImage(named: "Button1km"), for: .normal)
           case 5:
               button3km.setImage(UIImage(named: "Button3km"), for: .normal)
           default:
               break
           }
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
