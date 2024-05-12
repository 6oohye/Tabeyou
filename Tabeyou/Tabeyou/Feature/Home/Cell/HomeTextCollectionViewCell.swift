//
//  HomeTextCollectionViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/12/24.
//

import UIKit

struct HomeTextCollectionViewCellViewModel: Hashable{
    var headerText : String
}

class HomeTextCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var headerTextLabel: UILabel!
    
    
    func setViewModel(_ viewModel : HomeTextCollectionViewCellViewModel){
        headerTextLabel.text = viewModel.headerText
    }
}

extension HomeTextCollectionViewCell{
    static func headerTextLayout() -> NSCollectionLayoutSection{
        let itemSize : NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let item : NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize : NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group : NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section : NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none

        return section
    }
}
