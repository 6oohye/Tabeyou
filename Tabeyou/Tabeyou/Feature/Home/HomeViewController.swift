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
        case restaurantList
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
    private var compositinalLayout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { section, _ in
            switch Section(rawValue: section){
                
            case .banner:
                let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(165 / 393))
                let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                return section
                
            case .restaurantList:
                let itemSize : NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 2), heightDimension: .estimated(277))
                let item : NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 0, leading: 2.5, bottom: 0, trailing: 2.5)
                
                let groupSize : NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(277))
                let group : NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
              
                let section : NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.contentInsets = .init(top: 40, leading: 19 - 2.5, bottom: 0, trailing: 19 - 2.5)
                section.interGroupSpacing = 10
                return section
                
            case .none: return nil
            }
        }
      
    }()
    
    private var timer: Timer?
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, viewModel in
            switch Section(rawValue: indexPath.section){
                
            case .banner:
                guard let viewModel = viewModel as? HomeBannerCollectionViewCellViewModel,
                      let cell: HomeBannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as? HomeBannerCollectionViewCell else {return .init()}
                cell.setViewModel(viewModel)
                return cell
                
            case .restaurantList:
                guard let viewModel = viewModel as? HomeRestaurantCollectionViewCellViewModel,
                      let cell: HomeRestaurantCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRestaurantCollectionViewCell", for: indexPath) as? HomeRestaurantCollectionViewCell else {return .init()}
                cell.setViewModel(viewModel)
                return cell
                
            case .none:
                return .init()
            }
            
        })
        
        var snapShot: NSDiffableDataSourceSnapshot<Section, AnyHashable> = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        
        snapShot.appendSections([.banner])
        snapShot.appendItems([HomeBannerCollectionViewCellViewModel(bannerImage: UIImage(resource: .banner1)),
                              HomeBannerCollectionViewCellViewModel(bannerImage: UIImage(resource: .banner2)),
                              HomeBannerCollectionViewCellViewModel(bannerImage: UIImage(resource: .banner3))
                             ], toSection: .banner)
        
        snapShot.appendSections([.restaurantList])
        snapShot.appendItems([
            HomeRestaurantCollectionViewCellViewModel(imageUrl: "", title: "焼肉ライク新宿店1", station: "新宿駅", time: "営業 9:00-21:00", price: "1000円〜5000円"),
            HomeRestaurantCollectionViewCellViewModel(imageUrl: "", title: "焼肉ライク新宿店2", station: "新宿駅", time: "営業 9:00-21:00", price: "2000円〜5000円"),
            HomeRestaurantCollectionViewCellViewModel(imageUrl: "", title: "焼肉ライク新宿店3", station: "新宿駅", time: "営業 9:00-21:00", price: "3000円〜5000円"),
            HomeRestaurantCollectionViewCellViewModel(imageUrl: "", title: "焼肉ライク新宿店4", station: "新宿駅", time: "営業 9:00-21:00", price: "4000円〜5000円")
        ], toSection: .restaurantList)
        
        dataSource?.apply(snapShot)
        
        collectionView.collectionViewLayout = compositinalLayout
        
        startTimer()
        
    }
    
    //MARK: -バナー自動スライドを実装
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        let nextIndex = (currentIndex + 1) % collectionView.numberOfItems(inSection: 0)
        collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
        currentIndex = nextIndex
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
}


//#Preview{
//    UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! HomeViewController
//}
