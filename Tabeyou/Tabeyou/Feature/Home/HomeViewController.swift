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
            print("위치 서비스 허용 off")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.main.async {
                manager.startUpdatingLocation()
            }
        case .notDetermined, .restricted, .denied:
            print("위치 권한 상태가 충분하지 않습니다.")
        @unknown default:
            fatalError("알 수 없는 권한 상태.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("위치 업데이트!")
            print("위도 : \(location.coordinate.latitude)")
            print("경도 : \(location.coordinate.longitude)")
        }
    }
        
    // 위치 가져오기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보 가져오기 실패: \(error.localizedDescription)")
    }
     
    //MARK: - loadData
    private func loadData(){
        Task{
            do {
                let response: [Restaurant.Results.Shop] = try await networkService.getRestaurantData()
                let restaurantViewModels = response.map { shop -> HomeRestaurantCollectionViewCellViewModel in
                    return HomeRestaurantCollectionViewCellViewModel(
                        imageUrl: shop.photo.pc.m,
                        title: shop.name,
                        station: shop.station_name,
                        time:shop.intro,
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
    
    private func restaurantListCell(_ collectionView : UICollectionView,_ indexPath: IndexPath,_ viewModel: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = viewModel as? HomeRestaurantCollectionViewCellViewModel,
              let cell: HomeRestaurantCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRestaurantCollectionViewCell", for: indexPath) as? HomeRestaurantCollectionViewCell else {return .init()}
        cell.setViewModel(viewModel)
        return cell
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
    
    //!!!: - 이거하면 메모리 누수를 방지할 수는 있는데 타이머가 계속 안돌아감..
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        timer?.invalidate()
    //        timer = nil
    //    }
}

//MARK: - Preview Code
//#Preview{
//    UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! HomeViewController
//}
