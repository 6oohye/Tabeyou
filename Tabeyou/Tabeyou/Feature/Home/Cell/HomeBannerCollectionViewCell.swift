//
//  HomeBannerCollectionViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/10/24.
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
