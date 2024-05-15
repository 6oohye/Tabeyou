//
//  ResultDetailIMapCollectionViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/16/24.
//

import UIKit
import MapKit

struct ResultDetailIMapCollectionViewCellViewModel: Hashable{
    var headerText : String
    var address : String
    //카피하기 문구는 안넣어봄. 스토리보드그대로 뜨는지 확인용
}

class ResultDetailIMapCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var detailAddress: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    func setViewModel(_ viewModel : ResultDetailIMapCollectionViewCellViewModel){
        headerText.text = viewModel.headerText
        detailAddress.text = viewModel.address
    }
}

extension ResultDetailIMapCollectionViewCell{
    static func mapViewLayout() -> NSCollectionLayoutSection{
        let itemSize : NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item : NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize : NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group : NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section : NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none

        return section
    }
}
