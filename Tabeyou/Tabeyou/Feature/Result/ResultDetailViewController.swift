//
//  ResultDetailViewController.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/13/24.
//

import UIKit

class ResultDetailViewController: UIViewController {
    enum Section: Int{
        case restaurantInfo
        case mapInfo
        case mapbutton
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedRestaurant: ResultDetailViewModel?
    var isMainColor = false
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private let viewModel = ResultDetailViewModel()
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCustom()
        
        if let restaurant = selectedRestaurant {
            loadData()
        }
        
        configureCollectionView()
        applySnapshot()
    }
    
    // MARK: - Data Loading
    private func loadData() {
        viewModel.loadData { [weak self] in
            self?.applySnapshot()
        }
    }
    
    
    //MARK: - DataSource
    private func configureCollectionView() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .restaurantInfo:
                return ResultDetailInfoCollectionViewCell.resultDetailInfoLayout()
            case .mapInfo:
                return ResultDetailIMapCollectionViewCell.mapViewLayout()
            case .mapbutton:
                return ResultDetailIMapButtonCollectionViewCell.mapButtonLayout()
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, viewModel in
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            switch section {
            case .restaurantInfo:
                return self.restaurantInfoCell(collectionView, indexPath, viewModel)
            case .mapInfo:
                return self.mapInfoCell(collectionView, indexPath, viewModel)
            case .mapbutton:
                return self.mapbuttonCell(collectionView, indexPath, viewModel)
            }
        }
    }
    
    //MARK: - SnapShot
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.restaurantInfo, .mapInfo, .mapbutton])
        
        // Append restaurant info view model
        snapshot.appendItems(viewModel.resultDetailViewModel, toSection: .restaurantInfo)
        
        // Append map info cell view model
        snapshot.appendItems([viewModel.resultDetailViewModel], toSection: .mapInfo)
        
        // Append map button cell view model
        snapshot.appendItems([viewModel.resultDetailViewModel], toSection: .mapbutton)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    //MARK: - DataSoure > Cell
    private func restaurantInfoCell(_ collectionView : UICollectionView,_ indexPath: IndexPath,_ viewModel: AnyHashable) -> UICollectionViewCell{
        guard let viewModel = viewModel as? ResultDetailInfoCollectionViewCellViewModel,
              let cell: ResultDetailInfoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultDetailInfoCollectionViewCell", for: indexPath) as? ResultDetailInfoCollectionViewCell else {return .init()}
        
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func mapInfoCell(_ collectionView : UICollectionView,_ indexPath: IndexPath,_ viewModel: AnyHashable) -> UICollectionViewCell{
        guard let viewModel = viewModel as? ResultDetailIMapCollectionViewCellViewModel,
              let cell: ResultDetailIMapCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultDetailIMapCollectionViewCell", for: indexPath) as? ResultDetailIMapCollectionViewCell else {return .init()}
        
        // 셀의 테두리 설정
        let borderWidth: CGFloat = 1
        let borderColor =  AppColors.UIKit.gray1.cgColor
        
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = nil
        
        // 탑에 보더 추가
        let borderLayer = CALayer()
        borderLayer.backgroundColor = borderColor
        borderLayer.frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: borderWidth)
        cell.contentView.layer.addSublayer(borderLayer)
        
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func mapbuttonCell(_ collectionView : UICollectionView,_ indexPath: IndexPath,_ viewModel: AnyHashable) -> UICollectionViewCell{
        guard let viewModel = viewModel as? ResultDetailIMapButtonCollectionViewCellViewModel,
              let cell: ResultDetailIMapButtonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultDetailIMapButtonCollectionViewCell", for: indexPath) as? ResultDetailIMapButtonCollectionViewCell else {return .init()}
        cell.setViewModel(viewModel)
        return cell
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

