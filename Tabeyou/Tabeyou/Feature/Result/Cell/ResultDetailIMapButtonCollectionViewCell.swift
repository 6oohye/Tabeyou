//
//  ResultDetailIMapButtonCollectionViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/16/24.
//

import UIKit

struct ResultDetailIMapButtonCollectionViewCellViewModel : Hashable{
    let buttonImage : UIButton.ButtonType
}

class ResultDetailIMapButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mapButton: UIButton!
    
    func setViewModel(_ viewModel : ResultDetailIMapButtonCollectionViewCellViewModel){
        mapButton.setImage(UIImage(named: "MapBtn"), for: .normal)
    }
    
}

extension ResultDetailIMapButtonCollectionViewCell{
    static func mapButtonLayout() -> NSCollectionLayoutSection{
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 34, bottom: 16, trailing: 34)
        return section
    }
}
