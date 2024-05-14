//
//  HomeViewController.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/8/24.
//

import UIKit
import CoreLocation


class HomeViewController: UIViewController, CLLocationManagerDelegate {
    enum Section: Int{
        case banner
        case button
        case headerText
        case restaurantList
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var locationManager = CLLocationManager()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
    private var compositinalLayout: UICollectionViewCompositionalLayout = setCompositionalLayout()
    
    private let networkService = NetworkService(key: "863a73a43b3ef2b6")
    
    private var timer: Timer?
    private var currentIndex = 0
    
    //MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.setLocationManager()
        }
        
        loadData()
        
        setDataSource()
        
        collectionView.collectionViewLayout = compositinalLayout
        startTimer()
        
    }
    
    
    //MARK: - 位置情報
    fileprivate func setLocationManager() {
        // 델리게이트를 설정하고,
        locationManager.delegate = self
        // 거리 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 사용 허용 알림
        locationManager.requestWhenInUseAuthorization()
        // 위치 사용을 허용하면 현재 위치 정보를 가져옴
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        else {
            print("ロケーションサービス off") //위치서비스 허용off
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.main.async {
                manager.startUpdatingLocation()
            }
        case .notDetermined, .restricted, .denied:
            print("位置権限状態が十分ではありません") //위치 권한 상태가 충분하지 않습니다
        @unknown default:
            fatalError("不明権限状態。") // 알 수 없는 권한 상태.
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("位置アップデート!")
            print("緯度 : \(location.coordinate.latitude)")
            print("経度 : \(location.coordinate.longitude)")
        }
    }
    
    // 위치 가져오기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗: \(error.localizedDescription)")
    }
    
    //MARK: - loadData
    private func loadData(){
        Task{
            do {
                let response: [Restaurant.Results.Shop] = try await networkService.getRestaurantData(range: 1)
                let restaurantViewModels = response.map { shop -> HomeRestaurantCollectionViewCellViewModel in
                    return HomeRestaurantCollectionViewCellViewModel(
                        imageUrl: shop.photo.pc.m,
                        title: shop.name,
                        station: shop.station_name,
                        intro:shop.intro,
                        price: shop.budget.name
                    )
                }
                applySnapShot(restaurantViewModels: restaurantViewModels)
            } catch{
                print("network Error : \(error)")
            }
        }
    }
    
    //MARK: - CompositionalLayout
    private static func setCompositionalLayout() -> UICollectionViewCompositionalLayout{
        UICollectionViewCompositionalLayout { section, _ in
            switch Section(rawValue: section){
                
            case .banner:
                return HomeBannerCollectionViewCell.bannerLayout()
                
            case .button:
                return HomeButtonCollectionViewCell.buttonLayout()
                
            case .headerText:
                return HomeTextCollectionViewCell.headerTextLayout()
                
            case .restaurantList:
                return  HomeRestaurantCollectionViewCell.restaurantListLayout()
                
            case .none: return nil
            }
        }
    }
    
    //MARK: - DataSource
    private func setDataSource(){
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, viewModel in
            switch Section(rawValue: indexPath.section){
                
            case .banner:
                return self?.bannerCell(collectionView, indexPath, viewModel)
                
            case .button:
                return self?.buttonCell(collectionView, indexPath, viewModel)
                
            case .headerText:
                return self?.headerTextCell(collectionView, indexPath, viewModel)
                
            case .restaurantList:
                return self?.restaurantListCell(collectionView, indexPath, viewModel)
                
            case .none:
                return .init()
            }
            
        })
    }
    
    //MARK: - SnapShot
    private func applySnapShot(restaurantViewModels: [HomeRestaurantCollectionViewCellViewModel]){
        var snapShot: NSDiffableDataSourceSnapshot<Section, AnyHashable> = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        
        snapShot.appendSections([.banner])
        snapShot.appendItems([HomeBannerCollectionViewCellViewModel(bannerImage: UIImage(resource: .banner1)),
                              HomeBannerCollectionViewCellViewModel(bannerImage: UIImage(resource: .banner2)),
                              HomeBannerCollectionViewCellViewModel(bannerImage: UIImage(resource: .banner3))
                             ], toSection: .banner)
        
        snapShot.appendSections([.button])
        snapShot.appendItems([HomeButtonCollectionViewCellViewModel(buttonImage: .system)], toSection: .button)
        
        snapShot.appendSections([.headerText])
        snapShot.appendItems([HomeTextCollectionViewCellViewModel(headerText: "最寄りのグルメ店に！")], toSection: .headerText)
        
        snapShot.appendSections([.restaurantList])
        snapShot.appendItems(restaurantViewModels, toSection: .restaurantList)
        
        dataSource?.apply(snapShot)
    }
    
    //MARK: - DataSoure > Cell
    private func bannerCell(_ collectionView : UICollectionView,_ indexPath: IndexPath,_ viewModel: AnyHashable) -> UICollectionViewCell{
        guard let viewModel = viewModel as? HomeBannerCollectionViewCellViewModel,
              let cell: HomeBannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as? HomeBannerCollectionViewCell else {return .init()}
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func buttonCell(_ collectionView : UICollectionView,_ indexPath: IndexPath,_ viewModel: AnyHashable) -> UICollectionViewCell{
        guard let viewModel = viewModel as? HomeButtonCollectionViewCellViewModel,
              let cell: HomeButtonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeButtonCollectionViewCell", for: indexPath) as? HomeButtonCollectionViewCell else {return .init()}
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func headerTextCell(_ collectionView : UICollectionView,_ indexPath: IndexPath,_ viewModel: AnyHashable) -> UICollectionViewCell{
        guard let viewModel = viewModel as? HomeTextCollectionViewCellViewModel,
              let cell: HomeTextCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTextCollectionViewCell", for: indexPath) as? HomeTextCollectionViewCell else {return .init()}
        
        // 셀의 테두리 설정
        let borderWidth: CGFloat = 1
        let borderColor =  AppColors.UIKit.gray1.cgColor
        
        cell.contentView.layer.borderWidth = 0
        cell.contentView.layer.borderColor = nil
        
        // 탑에 보더 추가
        let borderLayer = CALayer()
        borderLayer.backgroundColor = borderColor
        borderLayer.frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: borderWidth)
        cell.contentView.layer.addSublayer(borderLayer)
        
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func restaurantListCell(_ collectionView : UICollectionView,_ indexPath: IndexPath,_ viewModel: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = viewModel as? HomeRestaurantCollectionViewCellViewModel,
              let cell: HomeRestaurantCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRestaurantCollectionViewCell", for: indexPath) as? HomeRestaurantCollectionViewCell else {return .init()}
        cell.setViewModel(viewModel)
        return cell
    }
    
    //300버튼 클릭
    @IBAction func Tapped300mButton(_ sender: Any) {
            // 이미 ResultListViewController가 스택에 있는지 확인
            if let resultListVC = navigationController?.viewControllers.first(where: { $0 is ResultListViewController }) as? ResultListViewController {
                // 스택에 있으면 range 값을 업데이트하고 데이터를 로드
                resultListVC.range = 1
                resultListVC.loadData(range: 1)
                // 이전 화면으로 이동
                navigationController?.popToViewController(resultListVC, animated: true)
            } else {
                // 스택에 없으면 새로운 ResultListViewController 인스턴스를 생성하여 데이터 로드
                if let resultListVC = storyboard?.instantiateViewController(withIdentifier: "ResultListViewController") as? ResultListViewController {
                    resultListVC.range = 1
                    navigationController?.pushViewController(resultListVC, animated: true)
                } else {
                    print("Failed to instantiate ResultListViewController from storyboard")
                }
            }
    }
    
    
    //MARK: - バナー自動スライドを実装
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        let nextIndex = (currentIndex + 1) % collectionView.numberOfItems(inSection: 0)
        collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
        currentIndex = nextIndex
    }

}
