//
//  ResultSortbyTableViewCell.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/18/24.
//

import UIKit

class ResultSortbyTableViewCell: UITableViewCell {

    @IBOutlet weak var defaultSortButton: UIButton!
    
    @IBOutlet weak var lowToHighPriceSortButton: UIButton!
    @IBOutlet weak var highToLowPriceSortButton: UIButton!
    
    // 버튼 액션: 가격 높은 순으로 정렬
        @IBAction func sortByPriceHighToLow(_ sender: UIButton) {
            delegate?.sortByPriceHighToLow()
        }
        
        // 버튼 액션: 가격 낮은 순으로 정렬
        @IBAction func sortByPriceLowToHigh(_ sender: UIButton) {
            delegate?.sortByPriceLowToHigh()
        }
        
        // 버튼 액션: 기본 순으로 정렬
        @IBAction func sortByDefault(_ sender: UIButton) {
            delegate?.sortByDefault()
            print("잘먹고있음")
        }
        
        // 델리게이트 프로토콜 정의
        weak var delegate: ResultSortbyTableViewCellDelegate?
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // 초기화 코드
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            // 선택 상태 설정 코드
        }
    }

    // 델리게이트 프로토콜 정의
    protocol ResultSortbyTableViewCellDelegate: AnyObject {
        func sortByPriceHighToLow()
        func sortByPriceLowToHigh()
        func sortByDefault()
    }
