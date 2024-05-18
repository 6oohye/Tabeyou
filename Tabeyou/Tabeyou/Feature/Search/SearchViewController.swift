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
  
    
    // 선택된 값을 저장할 변수
    var selectedValues: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 콘텐트뷰의 크기를 설정합니다.
        scrollView.contentSize = contentView.frame.size
        
        // 세로 스크롤이 항상 가능하도록 설정합니다.
        scrollView.alwaysBounceVertical = true
        
        // 콘텐트뷰가 화면 하단에 고정되도록 contentInset을 설정합니다.
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: contentView.frame.height, right: 0)
        
        //SearchBar UI
        self.searchBar.layer.cornerRadius = 5
        self.searchBar.searchBarStyle = .minimal
        
        //button
        let buttons: [UIButton] = [izakaya!, dining!, creativeCuisine!, japaneseFood!, westernFood!, italian!, chinese!, grilledMeat!, koreanFood!, cafe!, worldCuisine!, ramen!, bar!, okonomiyaki!, other!,wifiYes!,wifiNo!,wifiUnidentified!]

        for button in buttons {
            styleButton(button)
        }
        
    }
    
    private func styleButton(_ button: UIButton) {
        button.layer.borderWidth = 2.0
        button.layer.borderColor =  UIColor(named: "mainColor")?.cgColor
        button.layer.cornerRadius = 5.0
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "wh")
    }
    
    
    // 버튼을 클릭할 때 실행되는 메소드
    @IBAction func genreButtonTapped(_ sender: UIButton) {
        guard let selectedValue = sender.titleLabel?.text else {
            return
        }
        // 선택된 버튼의 타이틀을 출력합니다.
        print("Clicked button title:", selectedValue)
        
        if selectedValues.contains(selectedValue) {
            // 이미 선택된 값이라면 제거
            if let index = selectedValues.firstIndex(of: selectedValue) {
                selectedValues.remove(at: index)
            }
        } else {
            // 선택되지 않은 값이라면 추가
            selectedValues.append(selectedValue)
        }
        
        // 선택된 값을 출력합니다.
        print("Selected values:", selectedValues)
    }
    
    // Wi-Fi 버튼을 클릭할 때 실행되는 메소드
    @IBAction func wifiButtonTapped(_ sender: UIButton) {
        guard let selectedValue = sender.titleLabel?.text else {
            return
        }
        // 선택된 버튼의 타이틀을 출력합니다.
        print("Clicked Wi-Fi button title:", selectedValue)
        
        if selectedValues.contains(selectedValue) {
            // 이미 선택된 값이라면 제거
            if let index = selectedValues.firstIndex(of: selectedValue) {
                selectedValues.remove(at: index)
            }
        } else {
            // 선택되지 않은 값이라면 추가
            selectedValues.append(selectedValue)
        }
        
        // 선택된 값을 출력합니다.
        print("Selected values:", selectedValues)
    }
    
    // 검색 결과 버튼을 클릭할 때 실행되는 메소드
    @IBAction func searchResultButtonTapped(_ sender: UIButton) {
        // 선택된 값들을 가지고 ResultListViewController로 이동
        if !selectedValues.isEmpty {
            // ResultListViewController의 인스턴스를 가져옵니다.
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // 여기에 여러분이 사용하는 스토리보드의 이름을 넣어주세요.
            let resultListVC = storyboard.instantiateViewController(withIdentifier: "ResultListViewController") as! ResultListViewController
            
            // 선택된 값들을 전달합니다.
            resultListVC.selectedValues = selectedValues
            
            // 결과 목록 뷰 컨트롤러를 표시합니다.
            self.navigationController?.pushViewController(resultListVC, animated: true)
        } else {
            print("No values selected.")
        }
    }
}
