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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarCustom()
        
        self.setupTableView()

    }
    
    //MARK: - ResultTableViewCell呼び出す関数
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: ResultTableViewCell.identifire, bundle: nil),
                                forCellReuseIdentifier: ResultTableViewCell.identifire)
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
        ResultSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = ResultSection(rawValue: section) else{
            return 0
        }
        
        switch section{
        case .restaurant :
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = ResultSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section{
        case .restaurant :
            return tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifire, for: indexPath)
        }
    }
    
    
}



