//
//  ResultDetailViewModel.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/15/24.


import Foundation

class  ResultDetailViewModel{
    private let networkService = NetworkService(key: "863a73a43b3ef2b6")
    
    struct ResultDetailViewModel: Hashable{
        let id : String
        let imageUrl : String
        let kana_name: String
        let title : String
        let accsee : String
        let genre : String
        let open : String
        let close : String
        let address : String
    }
    var resultDetailViewModel: [ResultDetailViewModel] = []
    
    func loadData(restaurantId: String, completion: @escaping () -> Void) {
        Task {
            do {
                let response: Restaurant.Results = try await networkService.getRestaurantDetailData(restaurantID: restaurantId)
                self.resultDetailViewModel = response.shop.map { shop -> ResultDetailViewModel in
                    return ResultDetailViewModel(
                        id:shop.id,
                        imageUrl: shop.photo.pc.m,
                        kana_name: shop.name_kana,
                        title: shop.name,
                        accsee: shop.access,
                        genre: shop.genre.name,
                        open: shop.open,
                        close: shop.close,
                        address: shop.address)
                }
                completion()
            } catch {
                print("network Error : \(error)")
            }
        }
    }
}
