//
//  HomeBannerCollectionViewCell.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/10/24.
//

import UIKit

struct HomeBannerCollectionViewCellViewModel :Hashable{
    let bannerImage : UIImage
}

class HomeBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setViewModel(_ viewModel : HomeBannerCollectionViewCellViewModel){
        imageView.image = viewModel.bannerImage
    }
}

extension HomeBannerCollectionViewCell{
    static func bannerLayout() -> NSCollectionLayoutSection{
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(165 / 393))
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}
