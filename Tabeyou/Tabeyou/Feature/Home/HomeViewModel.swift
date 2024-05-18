//
//  HomeViewModel.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/10/24.
//

import Foundation

class HomeViewModel {
    private let networkService = NetworkService(key: "863a73a43b3ef2b6")
    
    //外部から修正されないように制限
    private(set) var restaurantViewModels: [HomeRestaurantCollectionViewCellViewModel] = []
    
    func printRestaurantIds() {
        for viewModel in restaurantViewModels {
            print(viewModel.id)
        }
    }
    
    
    func loadData(completion: @escaping () -> Void) {
        Task {
            do {
                let response: Restaurant.Results = try await networkService.getRestaurantData(range: 1, start: 1, page: 1)
                self.restaurantViewModels = response.shop.map { shop -> HomeRestaurantCollectionViewCellViewModel in
                    return HomeRestaurantCollectionViewCellViewModel(
                        id:shop.id,
                        imageUrl: shop.photo.pc.m,
                        title: shop.name,
                        station: shop.station_name,
                        intro: shop.intro,
                        price: shop.budget.name
                    )
                }
                completion()
            } catch {
                print("network Error : \(error)")
            }
        }
    }
}

