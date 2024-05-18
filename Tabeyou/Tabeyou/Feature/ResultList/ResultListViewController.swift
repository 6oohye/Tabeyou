//
//  ResultListViewController.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/13/24.
//

import UIKit

class ResultListViewController: UIViewController, ResultSortbyTableViewCellDelegate {
    
    enum ResultSection: Int, CaseIterable{
        case sortBy
        case restaurant
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ResultListViewModel()
    var currentSortOption: ResultListViewModel.SortOption = .default // 기본 정렬 방식
    
    var selectedValues: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarCustom()
        setupTableView()
        
        print("Selected values(성공): \(selectedValues)")
        
        
        loadData(sortBy: currentSortOption)
    }
    
    // MARK: - TableView Setup
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ResultSortbyTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultSortbyTableViewCell")
        tableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultTableViewCell")
        
        // ResultSortbyTableViewCell의 델리게이트 설정
        if let sortbyCell = tableView.dequeueReusableCell(withIdentifier: "ResultSortbyTableViewCell") as? ResultSortbyTableViewCell {
            sortbyCell.delegate = self
        }
    }
    
    
    // MARK: - API Data Loading
    private func loadData(sortBy option: ResultListViewModel.SortOption) {
        viewModel.fetchData(sortBy: option) { [weak self] in
            self?.tableView.reloadData()
        }
        currentSortOption = option // 현재 정렬 방식 업데이트
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ResultSection(rawValue: section)! {
        case .sortBy:
            return 1
        case .restaurant:
            return viewModel.restaurants.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch ResultSection(rawValue: indexPath.section)! {
        case .sortBy:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultSortbyTableViewCell", for: indexPath) as? ResultSortbyTableViewCell else {
                fatalError("Failed to dequeue ResultSortbyTableViewCell.")
            }
            cell.delegate = self // 델리게이트 설정
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
