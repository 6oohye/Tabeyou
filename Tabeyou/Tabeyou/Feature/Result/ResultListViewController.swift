//
//  ResultListViewController.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/13/24.
//

import UIKit

class ResultListViewController: UIViewController {
    
    enum ResultSection: Int, CaseIterable{
        case restaurant
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var restaurants: [ResultTableViewCellViewModel] = []
    private let networkService = NetworkService(key: "863a73a43b3ef2b6")
    var range: Int = 0
    var currentPage: Int = 1 // 현재 페이지를 추적하는 변수
    var isLoading: Bool = false // 데이터를 로드 중인지 추적하는 변수
    
    private var activityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarCustom()
        self.setupTableView()
        loadData()
        
    }
    
    //MARK: - ResultTableViewCell呼び出す関数
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(
            UINib(nibName: ResultTableViewCell.identifire, bundle: nil),
            forCellReuseIdentifier: ResultTableViewCell.identifire
        )
    }
    
    //MARK: - APIからデータを取得する
    private func loadData() {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            do {
                let response: Restaurant.Results = try await networkService.getRestaurantData(range: range, start: currentPage)
                
                // results_availableで範囲別にデータがよく入っているか確認用
                let resultsAvailable = response.results_available
                print("Results Available:", resultsAvailable)
                
                let restaurantViewModels = response.shop.map { shop -> ResultTableViewCellViewModel in
                    return ResultTableViewCellViewModel(
                        imageUrl: shop.photo.pc.m,
                        title: shop.name,
                        station: shop.station_name,
                        price: shop.budget.name,
                        access: shop.access
                    )
                }
                
                // 기존 데이터에 새로운 데이터 추가
                restaurants.append(contentsOf: restaurantViewModels)
                
                // 테이블 뷰 갱신
                tableView.reloadData()
                isLoading = false
                currentPage += 1 // 페이지 증가
                
            } catch {
                print("Error fetching data: \(error)")
                isLoading = false
            }
        }
    }
}

extension ResultListViewController{
    
    //MARK: - NavigationBar Custom
    func navigationBarCustom(){
        self.navigationItem.title = "検索結果"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .backArrow,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem?.tintColor = .bk
        
    }
    
    //MARK: - HomeViewControllerに移動
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ResultListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifire, for: indexPath) as? ResultTableViewCell else {
                return UITableViewCell()
            }
            
            // 셀에 데이터를 설정합니다.
            let restaurant = restaurants[indexPath.row]
            cell.setViewModel(restaurant)
            
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingViewCell", for: indexPath) as? LoadingViewCell else {
                return UITableViewCell()
            }
            
            cell.start()
            
            return cell
        }
    }
    //MARK: - ResultDetailに移動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToDetail", sender: nil)
    }
    
    // Segue를 통해 이동할 때 데이터 전달을 위한 메서드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetail" {
            // Segue가 실행될 때 필요한 작업을 수행하세요.
        }
    }
    
}


extension ResultListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 1.5 {
            loadData()
        }
    }
}
