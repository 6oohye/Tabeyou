//
//  ResultDetailViewController.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/13/24.
//

import UIKit
import MapKit
import Kingfisher

final class ResultDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var detailViewImage: UIImageView!
    @IBOutlet weak var infoStack: UIStackView!
    @IBOutlet weak var detailKanaName: UILabel!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailAccess: UILabel!
    @IBOutlet weak var detailGenre: UILabel!
    @IBOutlet weak var detailOpen: UILabel!
    @IBOutlet weak var detailClose: UILabel!
    @IBOutlet weak var detailAddress: UILabel!
    @IBOutlet weak var addressCopy: UIImageView!
    @IBOutlet weak var detailMap: MKMapView!
    @IBOutlet weak var detailMapButton: UIButton!
    
    
    
    
    var isMainColor = false
    var restaurantId: String?
    var viewModel = ResultDetailViewModel()
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCustom()
        setupScrollView()
        setupAddressCopyAction()
        loadData()
        detailMapButton.addTarget(self, action: #selector(openMaps), for: .touchUpInside)
        mapButtonBorder()
    }
    
    // MARK: - Scroll View設定
    func setupScrollView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    // MARK: - アドレスコピーアクション設定
    func setupAddressCopyAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyAddress))
        addressCopy.isUserInteractionEnabled = true
        addressCopy.addGestureRecognizer(tapGesture)
    }
    
    @objc func copyAddress() {
        guard let address = detailAddress.text else { return }
        UIPasteboard.general.string = address
        showCopyAlert()
    }
    
    func showCopyAlert() {
        let alert = UIAlertController(title: "コピーされました", message: "アドレスがクリップボードにコピーされました", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - データローディングメソッド
    func loadData() {
        guard let id = restaurantId else {
            print("レストランIDが見つかりません")
            return
        }
        print("Restaurant ID:", id) //レストランID確認用
        
        viewModel.loadData(restaurantId: id) { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    
    // MARK: - UIアップデートメソッド
    func updateUI() {
        guard let restaurant = viewModel.resultDetailViewModel.first else {
            return
        }
        detailViewImage.kf.setImage(with: URL(string: restaurant.imageUrl))
        detailKanaName.text = restaurant.kana_name
        detailName.text = restaurant.title
        detailAccess.text = restaurant.accsee
        detailGenre.text = restaurant.genre
        detailOpen.text = restaurant.open
        detailClose.text = restaurant.close
        detailAddress.text = restaurant.address
        
        // 住所を座標に変換して地図に表示
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(restaurant.address) { [weak self] (placemarks, error) in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("住所が見つかりません。")
                return
            }
            // 座標に基づいて地図にピンを表示
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = restaurant.title
            self?.detailMap.addAnnotation(annotation)
            
            // 地図の中心を該当する座標に移動
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self?.detailMap.setRegion(region, animated: true)
        }
    }
    
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
}

// MARK: - Extension : 地図アクション及びボタンデザイン
extension ResultDetailViewController{
    //MARK: - : 地図を開くアクション
    @objc func openMaps() {
        guard let address = detailAddress.text else {
            return
        }
        
        // 地図アプリを開いて住所に合わせて地図を表示
        if let url = URL(string: "http://maps.apple.com/?address=\(address)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("URLを開くことができません。")
        }
    }
    
    // MARK: - ボタンデザイン
    func mapButtonBorder(){
        detailMapButton.layer.borderColor = AppColors.UIKit.gray2.cgColor
        detailMapButton.layer.borderWidth = 2.0
        detailMapButton.layer.cornerRadius = 8.0
    }
}

// MARK: - Extension : NavigationBarアクション
extension ResultDetailViewController {
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
    
    //MARK: - bookmark Button アクション
    @IBAction func bookmarkButtonTapped(_ sender: UIBarButtonItem) {
        isMainColor.toggle()
        
        if isMainColor {
            sender.tintColor = UIColor(named: "mainColor")
        } else {
            sender.tintColor = .icongray
        }
    }
}
