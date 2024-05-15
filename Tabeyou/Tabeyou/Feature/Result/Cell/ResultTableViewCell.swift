//
//  ResultTableViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/13/24.
//

import UIKit
import Kingfisher

struct ResultTableViewCellViewModel: Hashable{
    let id : String
    let imageUrl : String
    let title : String
    let station : String
    let price : String
    let access : String
}

class ResultTableViewCell: UITableViewCell {
    
    static let identifire: String = "ResultTableViewCell"
    static let height : CGFloat = 100
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    
    func setViewModel(_ viewModel : ResultTableViewCellViewModel){
        restaurantImageView.kf.setImage(with: URL(string: viewModel.imageUrl))
        restaurantNameLabel.text = viewModel.title
        stationLabel.text = viewModel.station
        priceLabel.text = viewModel.price
        locationLabel.text = viewModel.access
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.borderColor = AppColors.UIKit.gray0.cgColor
        self.containerView.layer.borderWidth = 1
        
        // restaurantImageView 제약 조건 설정
        restaurantImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(restaurantImageView)
        
        NSLayoutConstraint.activate([
            // 이미지뷰 크기 고정
            restaurantImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // 이미지뷰를 containerView의 중앙에 정렬
            restaurantImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            // containerView의 상단과의 제약 조건 (우선 순위를 낮춤)
            restaurantImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).withPriority(.defaultLow),
            restaurantImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).withPriority(.defaultLow)
            
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

private extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
