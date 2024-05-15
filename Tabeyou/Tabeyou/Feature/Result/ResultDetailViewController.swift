//
//  ResultDetailViewController.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/13/24.
//

import UIKit
import MapKit
import Kingfisher

class ResultDetailViewController:
    UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailKanaName: UILabel!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailaccess: UILabel!
    @IBOutlet weak var detailGenre: UILabel!
    @IBOutlet weak var detailOpen: UILabel!
    @IBOutlet weak var detailClose: UILabel!
    @IBOutlet weak var detailMapView: MKMapView!
    @IBOutlet weak var detailCopyButton: UIButton!
    @IBOutlet weak var detailAddress: UILabel!
    @IBOutlet weak var detailMapButton: UIButton!
    
    var isMainColor = false
    var resultDetailViewModel = ResultDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCustom()
        
        
    }
    
    func setViewModel(_ viewModel: ResultDetailViewModel.ResultDetailViewModel){
        detailImageView.kf.setImage(with: URL(string:viewModel.imageUrl ))
        detailKanaName.text = viewModel.kana_name
        detailName.text = viewModel.title
        detailaccess.text = viewModel.accsee
        detailGenre.text = viewModel.genre
        detailOpen.text = viewModel.open
        detailClose.text = viewModel.close
        detailAddress.text = viewModel.address
    }
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
        self.navigationItem.rightBarButtonItem?.tintColor = .iconGray
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
            sender.tintColor = .iconGray
        }
    }
}

