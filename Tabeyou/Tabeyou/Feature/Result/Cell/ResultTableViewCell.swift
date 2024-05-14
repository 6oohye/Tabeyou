//
//  ResultTableViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/13/24.
//

import UIKit
import Kingfisher

//struct ResultTableViewCellViewModel: Hashable{
//
//}

 class ResultTableViewCell: UITableViewCell {
    
    static let identifire: String = "ResultTableViewCell"
    static let height : CGFloat = 100
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.borderColor = AppColors.UIKit.gray0.cgColor
        self.containerView.layer.borderWidth = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
