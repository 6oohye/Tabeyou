//
//  ResultDetailViewController.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/13/24.
//

import UIKit
import Kingfisher
import MapKit

class ResultDetailViewController: UIViewController {
    
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
        // 데이터 로딩 메서드 호출
        loadData()
        // 버튼 액션 설정
        detailMapButton.addTarget(self, action: #selector(openMaps), for: .touchUpInside)
        //보더
        mapButtonBorder()
    }
    
    func setupScrollView() {
            // 콘텐츠 뷰의 제약 조건 설정
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        }
    
    // 데이터 로딩 메서드
    func loadData() {
        guard let id = restaurantId else {
            print("No restaurantId found")
            return
        }
        
        print("Restaurant ID:", id)
        
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
        
        // 주소를 좌표로 변환하여 지도에 표시
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(restaurant.address) { [weak self] (placemarks, error) in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("주소를 찾을 수 없습니다.")
                return
            }
            // 좌표를 기반으로 지도에 핀을 표시합니다.
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = restaurant.title
            self?.detailMap.addAnnotation(annotation)
            
            // 지도의 중심을 해당 좌표로 이동합니다.
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


extension ResultDetailViewController{
    //MARK: - 버튼 액션: 지도 열기
    @objc func openMaps() {
        guard let address = detailAddress.text else {
            return
        }
        
        // 지도 앱을 열고 주소에 맞게 지도를 표시
        if let url = URL(string: "http://maps.apple.com/?address=\(address)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("URL을 열 수 없습니다.")
        }
    }
    
    
    func mapButtonBorder(){
        detailMapButton.layer.borderColor = AppColors.UIKit.gray2.cgColor
        detailMapButton.layer.borderWidth = 2.0
        detailMapButton.layer.cornerRadius = 8.0 // 원하는 값으로 설정
    }
}


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

