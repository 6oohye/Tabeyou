//
//  ResultTableViewCell.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/13/24.
//

import UIKit

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
        if let url = URL(string: viewModel.imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.restaurantImageView.image = image
                        }
                    }
                }
            }
        }
        restaurantNameLabel.text = viewModel.title
        stationLabel.text = viewModel.station
        priceLabel.text = viewModel.price
        locationLabel.text = viewModel.access
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.borderColor = AppColors.UIKit.gray0.cgColor
        self.containerView.layer.borderWidth = 1
        
        // restaurantImageViewの制約条件設定
        restaurantImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(restaurantImageView)
        
        NSLayoutConstraint.activate([
            // ImageViewサイズ固定
            restaurantImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // containerViewの中央に整列
            restaurantImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            // containerViewの上段との制約条件(優先順位を下げる)
            restaurantImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).withPriority(.defaultLow),
            restaurantImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).withPriority(.defaultLow)
            
        ])
    }
}

private extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
