//
//  HomeViewModel.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/10/24.
//

import Foundation

class HomeViewModel {
    private let networkService = NetworkService(key: "863a73a43b3ef2b6")

    var restaurantViewModels: [HomeRestaurantCollectionViewCellViewModel] = []
    

    func loadData(restaurantId: String,completion: @escaping () -> Void) {
        Task {
            do {
                let response: Restaurant.Results = try await networkService.getRestaurantData(range: 1, start: 1, page: 1,restaurantID: restaurantId )
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

