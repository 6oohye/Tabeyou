//
//  ResultListViewModel.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/15/24.
//

import Foundation

class ResultListViewModel {
    
    enum ResultSection: Int, CaseIterable {
        case restaurant
    }
    
    private var originalRestaurants: [ResultTableViewCellViewModel] = []
    var restaurants: [ResultTableViewCellViewModel] = []
    private let networkService = NetworkService(key: "863a73a43b3ef2b6")
    var range: Int = 0
    var start : Int = 1 //시작하는 id
    var currentPage: Int = 0 // 현재 페이지를 추적하는 변수
    var isLoading: Bool = false // 데이터를 로드 중인지 추적하는 변수
    var resultsAvailable: Int = 0 // 전체 결과 수를 저장하는 변수
    
    // 정렬 방식을 나타내는 열거형
    enum SortOption {
        case lowToHighPrice
        case highToLowPrice
        case `default`
    }
    
    func fetchData(sortBy option: SortOption, completion: @escaping () -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            do {
                let response: Restaurant.Results = try await networkService.getRestaurantData(range: range, start: start, page: currentPage)
                
                // results_available 값 확인
                resultsAvailable = response.results_available
                print("Results Available:", resultsAvailable)
                
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
                
                // 원래 배열에 새로운 데이터 추가
                originalRestaurants.append(contentsOf: restaurantViewModels)
                
                // 기본 정렬에도 원래 배열을 정렬
                sortRestaurants(by: .default)
                
                // 정렬 방식에 따라 데이터를 정렬
                sortRestaurants(by: option)
                
                // 기존 데이터에 새로운 데이터 추가
                restaurants.append(contentsOf: restaurantViewModels)
                
                isLoading = false
                currentPage += 1 // 페이지 증가
                start = ((currentPage) * 10 + 1)
                print("Page:", currentPage)
                print("Start:", start)
                
                // UI 업데이트는 메인 스레드에서 수행되어야 합니다.
                DispatchQueue.main.async {
                    completion()
                }
                
            } catch {
                print("Error fetching data: \(error)")
                isLoading = false
            }
        }
    }
    
    // SortOption에 따라 데이터를 정렬하는 메서드
    private func sortRestaurants(by option: SortOption) {
        switch option {
        case .lowToHighPrice:
            restaurants.sort { $0.price < $1.price }
        case .highToLowPrice:
            restaurants.sort { $0.price > $1.price }
        case .default: // 기본 정렬 방식 처리
            restaurants = originalRestaurants
            break
        }
    }
}
