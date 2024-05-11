//
//  HomeViewController.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/8/24.
//

import UIKit


class HomeViewController: UIViewController {
    enum Section: Int{
        case banner
        case button
        case restaurantList
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
    private var compositinalLayout: UICollectionViewCompositionalLayout = setCompositionalLayout()
   
    
    private var timer: Timer?
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataSource()
        applySnapShot()
        collectionView.collectionViewLayout = compositinalLayout
        startTimer()
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
    private func applySnapShot(){
        var snapShot: NSDiffableDataSourceSnapshot<Section, AnyHashable> = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        
        snapShot.appendSections([.banner])
        snapShot.appendItems([HomeBannerCollectionViewCellViewModel(bannerImage: UIImage(resource: .banner1)),
                              HomeBannerCollectionViewCellViewModel(bannerImage: UIImage(resource: .banner2)),
                              HomeBannerCollectionViewCellViewModel(bannerImage: UIImage(resource: .banner3))
                             ], toSection: .banner)
        
        snapShot.appendSections([.button])
        snapShot.appendItems([HomeButtonCollectionViewCellViewModel(buttonImage: .system)], toSection: .button)
        
        snapShot.appendSections([.restaurantList])
        snapShot.appendItems([
            HomeRestaurantCollectionViewCellViewModel(imageUrl: "", title: "焼肉ライク新宿店1", station: "新宿駅", time: "営業 9:00-21:00", price: "1000円〜5000円"),
            HomeRestaurantCollectionViewCellViewModel(imageUrl: "", title: "焼肉ライク新宿店2", station: "新宿駅", time: "営業 9:00-21:00", price: "2000円〜5000円"),
            HomeRestaurantCollectionViewCellViewModel(imageUrl: "", title: "焼肉ライク新宿店3", station: "新宿駅", time: "営業 9:00-21:00", price: "3000円〜5000円"),
            HomeRestaurantCollectionViewCellViewModel(imageUrl: "", title: "焼肉ライク新宿店4", station: "新宿駅", time: "営業 9:00-21:00", price: "4000円〜5000円")
        ], toSection: .restaurantList)
        
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
