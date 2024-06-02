//
//  HomeButtonCollectionViewCell.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/10/24.
//

import UIKit

struct HomeButtonCollectionViewCellViewModel : Hashable{
    let buttonImage : UIButton.ButtonType
}

final class HomeButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var button300m: UIButton!
    @IBOutlet weak var button500m: UIButton!
    @IBOutlet weak var button1km: UIButton!
    @IBOutlet weak var button3km: UIButton!
    
    
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
