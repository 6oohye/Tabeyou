//
//  ResultListViewModel.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/15/24.
//

import Foundation

class ResultListViewModel {
    
    // セクションを表す列挙型
    enum ResultSection: Int, CaseIterable {
        case restaurant
    }
    
    // オリジナルのレストランデータを保持する配列
    private var originalRestaurants: [ResultTableViewCellViewModel] = []
    // 表示用のレストランデータを保持する配列
    var restaurants: [ResultTableViewCellViewModel] = []
    // ネットワークサービスのインスタンス
    private let networkService = NetworkService(key: "863a73a43b3ef2b6")
    var range: Int = 0 // データ取得の範囲
    var start : Int = 1 //データ取得の開始位置
    var currentPage: Int = 0 // 現在のページを追跡する変数
    var isLoading: Bool = false // データをロード中かどうかを追跡する変数
    var resultsAvailable: Int = 0 // 全結果数を保存する変数
    
    // ソートオプションを表す列挙型
    enum SortOption {
        case lowToHighPrice
        case highToLowPrice
        case `default`
    }
    
    // データを取得するメソッド
    func fetchData(sortBy option: SortOption, completion: @escaping () -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        // 非同期タスクでデータを取得
        Task {
            do {
                let response: Restaurant.Results = try await networkService.getRestaurantData(range: range, start: start, page: currentPage)
                
                // 全体の結果数を確認する
                resultsAvailable = response.results_available
                print("Results Available:", resultsAvailable)
                
                // レストランデータをビューモデルに変換
                let restaurantViewModels = response.shop.map { shop -> ResultTableViewCellViewModel in
                    return ResultTableViewCellViewModel(
                        id: shop.id,
                        imageUrl: shop.photo.pc.m,
                        title: shop.name,
                        station: shop.station_name,
                        price: shop.budget.name,
                        access: shop.access
                    )
                }
                
                // 元のレストランデータ配列に新しいデータを追加
                originalRestaurants.append(contentsOf: restaurantViewModels)
                
                // 新しいデータを表示用の配列に追加
                restaurants.append(contentsOf: restaurantViewModels)
                
                // 整列方式によってデータを整列
                sortRestaurants(by: option)
                
                // UIアップデートはメインスレッドで実施
                DispatchQueue.main.async {
                    completion()
                }
            
                // ロード状態を解除し、ページ番号を更新
                isLoading = false
                currentPage += 1 // ページを増加
                start = ((currentPage) * 10 + 1) // 次のデータ開始位置を更新
                print("Page:", currentPage)
                print("Start:", start)
                
            } catch {
                // エラーが発生した場合の処理
                print("Error fetching data: \(error)")
                isLoading = false
            }
        }
    }
    
    // SortOptionに従ってデータをソートする
    private func sortRestaurants(by option: SortOption) {
        switch option {
        case .lowToHighPrice:
            restaurants.sort { $0.price < $1.price }
        case .highToLowPrice:
            restaurants.sort { $0.price > $1.price }
        case .default: // 元のレストランデータでソート
            restaurants = originalRestaurants
        }
    }
}
