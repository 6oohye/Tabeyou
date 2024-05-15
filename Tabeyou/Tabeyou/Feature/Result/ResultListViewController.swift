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
    
    var viewModel = ResultListViewModel()
    
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
        viewModel.fetchData { [weak self] in
            self?.tableView.reloadData()
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifire, for: indexPath) as? ResultTableViewCell else {
            return UITableViewCell()
        }
        
        let restaurant = viewModel.restaurants[indexPath.row]
        cell.setViewModel(restaurant)
        
        return cell
    }
    
    //MARK: - ResultDetailに移動
    // tableView에서 셀을 클릭했을 때 호출되는 메서드
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // 선택된 셀의 데이터를 가져옴
           let selectedRestaurant = viewModel.restaurants[indexPath.row]
           // 디테일 뷰로 이동하기 위한 세그웨이 실행
           performSegue(withIdentifier: "GoToDetail", sender: selectedRestaurant)
       }

       // Segue를 통해 이동할 때 데이터 전달을 위한 메서드
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Segue의 식별자가 GoToDetail이고, 디테일 뷰 컨트롤러인 경우
           if segue.identifier == "GoToDetail",
              let destinationVC = segue.destination as? ResultDetailViewController,
              let selectedRestaurant = sender as? ResultDetailViewModel {
               // 선택된 셀의 데이터를 디테일 뷰 컨트롤러에 전달
               destinationVC.selectedRestaurant = selectedRestaurant
           }
       }
    
}

//MARK: - List Paging 処理
extension ResultListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 1.5 && !viewModel.isLoading {
            if viewModel.restaurants.count < viewModel.resultsAvailable {
                loadData()
            }
        }
    }
}
