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
    


}
