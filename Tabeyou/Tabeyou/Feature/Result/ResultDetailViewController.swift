//
//  ResultDetailViewController.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/13/24.
//

import UIKit

class ResultDetailViewController: UIViewController {
    var isMainColor = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCustom()
        
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

