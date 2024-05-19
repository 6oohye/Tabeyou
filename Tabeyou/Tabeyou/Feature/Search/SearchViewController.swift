//
//  SearchViewController.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/10/24.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //ジャンル Button
    @IBOutlet weak var izakaya: UIButton!
    @IBOutlet weak var dining: UIButton!
    @IBOutlet weak var creativeCuisine: UIButton!
    @IBOutlet weak var japaneseFood: UIButton!
    @IBOutlet weak var westernFood: UIButton!
    @IBOutlet weak var italian: UIButton!
    @IBOutlet weak var chinese: UIButton!
    @IBOutlet weak var grilledMeat: UIButton!
    @IBOutlet weak var koreanFood: UIButton!
    @IBOutlet weak var cafe: UIButton!
    @IBOutlet weak var worldCuisine: UIButton!
    @IBOutlet weak var ramen: UIButton!
    @IBOutlet weak var bar: UIButton!
    @IBOutlet weak var okonomiyaki: UIButton!
    @IBOutlet weak var other: UIButton!
    
    //Wi-Fi Button
    @IBOutlet weak var wifiYes: UIButton!
    @IBOutlet weak var wifiNo: UIButton!
    @IBOutlet weak var wifiUnidentified: UIButton!
    
    //ResultListViewControllerに移動するボタン
    @IBOutlet weak var searchResultButton: UIButton!
  
    
    // 選択された値を保存する変数
    var selectedValues: [String] = []
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //スクロールビュー設定
        scrollView.contentSize = contentView.frame.size
        scrollView.alwaysBounceVertical = true
        let bottomInset = max(view.bounds.height - contentView.frame.maxY, 0)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        
        //SearchBar UI
        self.searchBar.layer.cornerRadius = 5
        self.searchBar.searchBarStyle = .minimal
    }
    
    
    // Genre、Wi-Fiボタンを処理するメソッド
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let selectedValue = sender.titleLabel?.text else {
            return
        }
        
        if selectedValues.contains(selectedValue) {
            // 選択済みの値なら削除します
            if let index = selectedValues.firstIndex(of: selectedValue) {
                selectedValues.remove(at: index)
                sender.backgroundColor = UIColor(named: "wh")
            }
        } else {
            // 選択されていない値であれば追加します
            selectedValues.append(selectedValue)
            sender.backgroundColor = UIColor(named: "lightRed2")
        }
        
        // 選択された値の出力 (デバッグ用)
        print("Selected values:", selectedValues)
    }
    
    //MARK: - 検索結果ボタンをクリックするときに実行されるメソッド
    @IBAction func searchResultButtonTapped(_ sender: UIButton) {
        // 選択された値を持ってResultListViewControllerに移動
        if !selectedValues.isEmpty {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let resultListVC = storyboard.instantiateViewController(withIdentifier: "ResultListViewController") as! ResultListViewController
            
            // 選択された値を渡す
            resultListVC.selectedValues = selectedValues
            
            // 結果リスト ビュー コントローラーを表示
            self.navigationController?.pushViewController(resultListVC, animated: true)
        } else {
            print("No values selected.")
        }
    }
}
