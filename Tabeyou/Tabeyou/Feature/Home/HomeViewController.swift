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
    
    
    private var timer: Timer?
    private var currentIndex = 0
    
    private let viewModel = HomeViewModel()
    
    //MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global().async {
            self.setLocationManager()
        }
        
        collectionView.delegate = self
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
    private func loadData() {
        viewModel.loadData { [weak self] in
            guard let self = self else { return }
            self.applySnapShot(restaurantViewModels: self.viewModel.restaurantViewModels)
            self.viewModel.printRestaurantIds()
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
        cell.isUserInteractionEnabled = true
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
    
}




extension HomeViewController {
    // Button 디테일뷰로 이동
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultListVC = segue.destination as? ResultListViewController {
            switch segue.identifier {
            case "GoTo300mList":
                resultListVC.viewModel.range = 1
            case "GoTo500mList":
                resultListVC.viewModel.range = 2
            case "GoTo1kmList":
                resultListVC.viewModel.range = 3
            case "GoTo3kmList":
                resultListVC.viewModel.range = 5
            default:
                break
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .restaurantList:
            // 선택한 셀의 레스토랑 정보를 가져옵니다.
            let selectedRestaurant = viewModel.restaurantViewModels[indexPath.item]
            
            // ResultDetailViewController로 이동하고 선택한 레스토랑의 ID를 전달합니다.
            if let resultDetailVC = storyboard?.instantiateViewController(withIdentifier: "ResultDetailViewController") as? ResultDetailViewController {
                resultDetailVC.restaurantId = selectedRestaurant.id
                navigationController?.pushViewController(resultDetailVC, animated: true)
            }
            
        default:
            break
        }
    }
}


