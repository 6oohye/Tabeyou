//
//  ResultDetailInfoCollectionViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/16/24.
//

import UIKit
import Kingfisher

struct ResultDetailInfoCollectionViewCellViewModel: Hashable{
        let id : String
        let imageUrl : String
        let kana_name: String
        let title : String
        let accsee : String
        let genre : String
        let open : String
        let close : String
        let address : String
    }

class ResultDetailInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailKanaName: UILabel!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailAccess: UILabel!
    @IBOutlet weak var detailGenre: UILabel!
    @IBOutlet weak var detailOpen: UILabel!
    @IBOutlet weak var detailClose: UILabel!
    
    
    
    func setViewModel(_ viewModel :ResultDetailInfoCollectionViewCellViewModel ){
        detailImage.kf.setImage(with: URL(string: viewModel.imageUrl))
        detailKanaName.text = viewModel.kana_name
        detailName.text = viewModel.title
        detailAccess.text = viewModel.accsee
        detailGenre.text = viewModel.genre
        detailOpen.text = viewModel.open
        detailClose.text = viewModel.close
    }
    
}

extension ResultDetailInfoCollectionViewCell {
    static func resultDetailInfoLayout() -> NSCollectionLayoutSection{
        let itemSize : NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item : NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize : NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group : NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section : NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none

        return section
    }
}
