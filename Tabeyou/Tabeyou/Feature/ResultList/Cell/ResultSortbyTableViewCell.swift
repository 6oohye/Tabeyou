//
//  ResultSortbyTableViewCell.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/18/24.
//

import UIKit

protocol ResultSortbyTableViewCellDelegate: AnyObject {
    func sortByPriceHighToLow()
    func sortByPriceLowToHigh()
    func sortByDefault()
}

final class ResultSortbyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var defaultSortButton: UIButton!
    @IBOutlet weak var lowToHighPriceSortButton: UIButton!
    @IBOutlet weak var highToLowPriceSortButton: UIButton!
    
    weak var delegate: ResultSortbyTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 初期設定:デフォルトのソートボタンを選択した状態に設定
        highlightSelectedButton(defaultSortButton)
    }
    
    // 価格の高い順に並べ替え
    @IBAction func sortByPriceHighToLow(_ sender: UIButton) {
        delegate?.sortByPriceHighToLow()
        highlightSelectedButton(sender)
    }
    
    // 低価格の順に並べ替え
    @IBAction func sortByPriceLowToHigh(_ sender: UIButton) {
        delegate?.sortByPriceLowToHigh()
        highlightSelectedButton(sender)
    }
    
    // 基本順に整列
    @IBAction func sortByDefault(_ sender: UIButton) {
        delegate?.sortByDefault()
        highlightSelectedButton(sender)
    }
    
    // 背景色アップデートメソッド
    private func highlightSelectedButton(_ selectedButton: UIButton) {
        // すべてのボタンをデフォルトの背景色に設定
        defaultSortButton.backgroundColor = .clear
        lowToHighPriceSortButton.backgroundColor = .clear
        highToLowPriceSortButton.backgroundColor = .clear
        
        // クリックしたボタンの背景色を変更
        selectedButton.backgroundColor = UIColor(named: "gray3")
        selectedButton.layer.cornerRadius = 5.0
        
    }
}
