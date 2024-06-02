//
//  ResultListViewController.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/13/24.
//

import UIKit

final class ResultListViewController: UIViewController, ResultSortbyTableViewCellDelegate {
    
    enum ResultSection: Int, CaseIterable{
        case sortBy
        case restaurant
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ResultListViewModel()
    var currentSortOption: ResultListViewModel.SortOption = .default
    
    var selectedValues: [String] = []
    
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarCustom()
        setupTableView()
        
        if let lat = latitude, let lng = longitude {
            viewModel.updateLocation(latitude: lat, longitude: lng)
        }
        
        loadData(sortBy: currentSortOption)
    }
    
    // MARK: - TableView 設定
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ResultSortbyTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultSortbyTableViewCell")
        tableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultTableViewCell")
        
        //ResultSortbyTableViewCellのデリゲート設定
        if let sortbyCell = tableView.dequeueReusableCell(withIdentifier: "ResultSortbyTableViewCell") as? ResultSortbyTableViewCell {
            sortbyCell.delegate = self
        }
    }
    
    
    // MARK: - 指定された整列オプションに従ってAPIからデータを取得し、Table Viewを再ロード
    private func loadData(sortBy option: ResultListViewModel.SortOption) {
        viewModel.fetchData(sortBy: option) { [weak self] in
            self?.tableView.reloadData()
        }
        currentSortOption = option
    }
    
    // MARK: - NavigationBar Customization
    func navigationBarCustom() {
        navigationItem.title = "検索結果"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    // MARK: - Back Button Action
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension ResultListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ResultSection.allCases.count
    }
    //MARK: - 各行に該当するセルを設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ResultSection(rawValue: section)! {
        case .sortBy:
            return 1
        case .restaurant:
            return viewModel.restaurants.count
        }
    }
    //MARK: - 各行に該当するセルを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch ResultSection(rawValue: indexPath.section)! {
        case .sortBy:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultSortbyTableViewCell", for: indexPath) as? ResultSortbyTableViewCell else {
                fatalError("Failed to dequeue ResultSortbyTableViewCell.")
            }
            cell.delegate = self
            return cell
        case .restaurant:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as? ResultTableViewCell else {
                return UITableViewCell()
            }
            let restaurant = viewModel.restaurants[indexPath.row]
            cell.setViewModel(restaurant)
            return cell
        }
    }
    
    // MARK: - Result Detail Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == ResultSection.restaurant.rawValue {
            let selectedRestaurantID = viewModel.restaurants[indexPath.row].id
            performSegue(withIdentifier: "GoToDetail", sender: selectedRestaurantID)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetail", let restaurantID = sender as? String {
            let goToDetail = segue.destination as! ResultDetailViewController
            goToDetail.restaurantId = restaurantID
        }
    }
}

// MARK: - List Paging
extension ResultListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 1.5 && !viewModel.isLoading {
            if viewModel.restaurants.count < viewModel.resultsAvailable {
                loadData(sortBy: currentSortOption)
            }
        }
    }
}

// MARK: - ResultSortbyTableViewCellDelegate
extension ResultListViewController {
    func sortByPriceHighToLow() {
        loadData(sortBy: .highToLowPrice) // 価格の高い順に並べ替えてデータを再ロード
    }
    
    func sortByPriceLowToHigh() {
        loadData(sortBy: .lowToHighPrice) // 低価格の順に並べ替えてデータを再ロード
    }
    
    func sortByDefault() {
        loadData(sortBy: .default) // 基本整列方式でデータを再ロード
    }
}
