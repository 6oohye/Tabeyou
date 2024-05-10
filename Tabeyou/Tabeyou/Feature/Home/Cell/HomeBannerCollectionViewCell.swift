//
//  HomeBannerCollectionViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/10/24.
//

import UIKit

class HomeBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(_ image : UIImage){
        imageView.image = image
    }
    
    
}
