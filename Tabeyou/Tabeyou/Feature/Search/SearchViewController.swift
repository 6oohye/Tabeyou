//
//  SearchViewController.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/10/24.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //ジャンル
    @IBOutlet weak var izakaya: CustomButton!
    @IBOutlet weak var dining: CustomButton!
    @IBOutlet weak var creativeCuisine: CustomButton!
    @IBOutlet weak var japaneseFood: CustomButton!
    @IBOutlet weak var westernFood: CustomButton!
    @IBOutlet weak var italian: CustomButton!
    @IBOutlet weak var chinese: CustomButton!
    @IBOutlet weak var grilledMeat: CustomButton!
    @IBOutlet weak var koreanFood: CustomButton!
    @IBOutlet weak var cafe: CustomButton!
    @IBOutlet weak var worldCuisine: CustomButton!
    @IBOutlet weak var ramen: CustomButton!
    @IBOutlet weak var bar: CustomButton!
    @IBOutlet weak var okonomiyaki: CustomButton!
    @IBOutlet weak var other: CustomButton!
    
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
    
    // 검색 결과 버튼을 클릭할 때 실행되는 메소드
    @IBAction func searchResultButtonTapped(_ sender: UIButton) {
        // 선택된 값들을 가지고 ResultListViewController로 이동
        goToDetailResults(with: selectedValues)
    }
    
    // ResultListViewController로 이동하는 메소드
    func goToDetailResults(with values: [String]) {
        performSegue(withIdentifier: "goToDetailResults", sender: values)
    }
    
    // 다음 화면으로 데이터를 전달하기 위한 메소드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ResultListViewController,
           let values = sender as? [String] {
            destinationVC.selectedValues = values
        }
    }
    
    
}
