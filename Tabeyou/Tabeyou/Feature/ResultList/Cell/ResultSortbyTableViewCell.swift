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
        updateButtonBackground(sender)
    }
    
    // 버튼 액션: 가격 낮은 순으로 정렬
    @IBAction func sortByPriceLowToHigh(_ sender: UIButton) {
        delegate?.sortByPriceLowToHigh()
        updateButtonBackground(sender)
    }
    
    // 버튼 액션: 기본 순으로 정렬
    @IBAction func sortByDefault(_ sender: UIButton) {
        delegate?.sortByDefault()
        updateButtonBackground(sender)
    }
    
    // 델리게이트 프로토콜 정의
    weak var delegate: ResultSortbyTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 초기화 코드
                // 처음에 기본순이 선택되도록 설정
                updateButtonBackground(defaultSortButton)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // 선택 상태 설정 코드
    }
    
    // 배경색 업데이트 메서드
       private func updateButtonBackground(_ selectedButton: UIButton) {
           // 모든 버튼을 기본 배경색으로 설정
           defaultSortButton.backgroundColor = .clear
           lowToHighPriceSortButton.backgroundColor = .clear
           highToLowPriceSortButton.backgroundColor = .clear
           
           // 클릭된 버튼의 배경색을 변경
           selectedButton.backgroundColor = UIColor(named: "gray3")
           selectedButton.layer.cornerRadius = 5.0
           
       }
}

// 델리게이트 프로토콜 정의
protocol ResultSortbyTableViewCellDelegate: AnyObject {
    func sortByPriceHighToLow()
    func sortByPriceLowToHigh()
    func sortByDefault()
}
