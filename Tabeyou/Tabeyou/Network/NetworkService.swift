//
//  NetworkService.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/11/24.
//

import Foundation
class NetworkService{
    static let shard : NetworkService = NetworkService()
    
    //MARK: -　グルメサーチAPIを活用してレストランの詳細情報を取得する機能
    func getGourmetData() async throws -> RestaurantResponse{
        let urlString = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=863a73a43b3ef2b6&large_area=Z011"
        guard let url = URL(string: urlString) else {throw URLError(.badURL)}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpRespons = response as? HTTPURLResponse, httpRespons.statusCode == 200 else {throw URLError(.badServerResponse)}
        let decodeData = try JSONDecoder().decode(RestaurantResponse.self, from: data)
        return decodeData
    }
}
