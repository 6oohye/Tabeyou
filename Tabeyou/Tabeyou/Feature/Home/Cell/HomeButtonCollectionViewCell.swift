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
    @IBOutlet weak var button5km: UIButton!
    
    func setViewModel(_ viewModel : HomeButtonCollectionViewCellViewModel){
        button300m.setImage(UIImage(named: "Button300m"), for: .normal)
        button500m.setImage(UIImage(named: "Button500m"), for: .normal)
        button1km.setImage(UIImage(named: "Button1km"), for: .normal)
        button5km.setImage(UIImage(named: "Button5km"), for: .normal)
        
    }
    
}
