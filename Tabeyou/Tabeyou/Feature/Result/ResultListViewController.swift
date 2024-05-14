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
    
    //MARK: - API로부터 데이터 가져오기
    private func loadData() {
        Task {
                    do {
                        let response: [Restaurant.Results.Shop] = try await networkService.getRestaurantData(range: range)
                        let restaurantViewModels = response.map { shop -> ResultTableViewCellViewModel in
                            return ResultTableViewCellViewModel(
                                imageUrl: shop.photo.pc.m,
                                title: shop.name,
                                station: shop.station_name,
                                price: shop.budget.name,
                                access: shop.access
                            )
                        }
                        restaurants = restaurantViewModels
                        
                        // 데이터를 가져온 후에 테이블 뷰를 리로드하여 업데이트된 데이터를 반영합니다.
                        tableView.reloadData()
                    } catch {
                        print("Error fetching data: \(error)")
                    }
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

extension ResultListViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1 // 섹션은 하나만 있습니다.
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return restaurants.count // 데이터의 개수만큼 셀을 반환합니다.
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifire, for: indexPath) as? ResultTableViewCell else {
               return UITableViewCell()
           }
           
           // 셀에 데이터를 설정합니다.
           let restaurant = restaurants[indexPath.row]
           cell.setViewModel(restaurant)
           
           return cell
       }
       
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // 선택된 셀에 해당하는 레스토랑 정보 가져오기
//        let selectedRestaurant = restaurants[indexPath.row]
//        
//        // 이동할 뷰 컨트롤러를 인스턴스화
//        let detailViewController = ResultDetailViewController()
//        
//        // 선택된 레스토랑 정보를 상세 뷰 컨트롤러에 전달
//        detailViewController.self = selectedRestaurant
//
//        // 뷰 컨트롤러를 표시
//        navigationController?.pushViewController(detailViewController, animated: true)
//    }
    
    
}



