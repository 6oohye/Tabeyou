//
//  ResultListViewModel.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/15/24.
//

import Foundation

class ResultListViewModel {
    
    enum ResultSection: Int, CaseIterable {
        case restaurant
    }
    
    var restaurants: [ResultTableViewCellViewModel] = []
    private let networkService = NetworkService(key: "863a73a43b3ef2b6")
    var range: Int = 0
    var start : Int = 1 //시작하는 id
    var currentPage: Int = 0 // 현재 페이지를 추적하는 변수
    var isLoading: Bool = false // 데이터를 로드 중인지 추적하는 변수
    var resultsAvailable: Int = 0 // 전체 결과 수를 저장하는 변수
    
    func fetchData(completion: @escaping () -> Void) {
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
}
