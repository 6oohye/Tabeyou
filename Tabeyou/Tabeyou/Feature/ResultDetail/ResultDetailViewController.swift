//
//  ResultDetailViewController.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/13/24.
//

import UIKit
import Kingfisher

class ResultDetailViewController: UIViewController {
    
    @IBOutlet weak var detailViewImage: UIImageView!
    @IBOutlet weak var detailKanaName: UILabel!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailAccess: UILabel!
    @IBOutlet weak var detailGenre: UILabel!
    @IBOutlet weak var detailOpen: UILabel!
    @IBOutlet weak var detailClose: UILabel!
    @IBOutlet weak var detailAddress: UILabel!
    
    
    
    
    var isMainColor = false
    var restaurantId: String?
    var viewModel = ResultDetailViewModel()
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCustom()
        // 데이터 로딩 메서드 호출
        loadData()
    }
    // 데이터 로딩 메서드
    func loadData() {
        guard let id = restaurantId else {
            return
        }
        
        viewModel.loadData(restaurantId: id) { [weak self] in
            DispatchQueue.main.async {
                // 데이터를 받아와 UI에 표시
                self?.updateUI()
            }
        }
    }
    
    // UI 업데이트 메서드
    func updateUI() {
        guard let restaurant = viewModel.resultDetailViewModel.first else {
            return
        }
        // 레이블에 데이터 표시
        detailViewImage.kf.setImage(with: URL(string: restaurant.imageUrl))
        detailKanaName.text = restaurant.kana_name
        detailName.text = restaurant.title
        detailAccess.text = restaurant.accsee
        detailGenre.text = restaurant.genre
        detailOpen.text = restaurant.open
        detailClose.text = restaurant.close
        detailAddress.text = restaurant.address
    }
    //    func getRestaurantID(){
    //        // 선택된 셀의 ID를 출력해보기
    //        if let id = restaurantId {
    //            print("Selected restaurant ID:", id)
    //            // 여기서 선택된 셀의 ID를 사용하여 데이터를 가져와 화면에 표시할 수 있음
    //        }
    //    }
    
    
}

extension ResultDetailViewController{
    //MARK: - NavigationBar Custom
    func navigationBarCustom(){
        //左アイコン設定
        let backButton = UIBarButtonItem(
            image: .backArrow,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        let homeButton = UIBarButtonItem(
            image: .homeIconStroke,
            style: .plain,
            target: self,
            action: #selector(goToHome)
        )
        backButton.tintColor = UIColor(named: "bk")
        homeButton.tintColor = UIColor(named: "bk")
        self.navigationItem.leftBarButtonItems = [backButton, homeButton]
        
        //右アイコン設定
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .bookmarkIconStroke,
            style: .plain,
            target: self,
            action: #selector(bookmarkButtonTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = .icongray
    }
    
    //MARK: - 前のページに移動
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - HomeViewControllerに移動
    @objc func goToHome() {
        if let homeViewController = navigationController?.viewControllers.first(where: { $0 is HomeViewController }) {
            navigationController?.popToViewController(homeViewController, animated: true)
        }
    }
    
    //MARK: - bookmark Button クリックした時にイメージ変更
    @IBAction func bookmarkButtonTapped(_ sender: UIBarButtonItem) {
        // 현재 색을 토글합니다.
        isMainColor.toggle()
        
        // 토글된 색에 따라 버튼의 색상을 설정합니다.
        if isMainColor {
            sender.tintColor = UIColor(named: "mainColor")
        } else {
            sender.tintColor = .icongray
        }
    }
}

