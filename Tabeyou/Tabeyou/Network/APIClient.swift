//
//  APIClient.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/11/24.
//

import Foundation

class APIClient{
    
    let baseURL = "https://webservice.recruit.co.jp/hotpepper"
    
    //TODO: - 라이브러리 사용자가 본인의 API키값을 받아쓸 수 있게 설정
    let key : String
    init(key: String) {
        self.key = key
    }
    
    func Fetch <Response : Decodable> (
        path : String, //gourmet/v1
        httpMethod : HTTPMethod,
        queryItems : [URLQueryItem]? = nil
    ) async throws -> Response{
        //URLRequest
        let urlRequest = try URLRequest(
            urlString: "\(baseURL)/\(path)",
            httpMethod: httpMethod,
            key: key,
            queryItems: queryItems
        )
        
        //URLSession Data
      let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        //HTTP URL Response
        if let error = APIError(httpResponse: urlResponse as? HTTPURLResponse) {
            throw error
        }
        // Decoding
        let output = try JSONDecoder().decode(Response.self, from: data)
        return output
    }
}









//class NetworkService{
//    static let shard : NetworkService = NetworkService()
//
//    //MARK: -　グルメサーチAPIを活用してレストランの詳細情報を取得する機能
//    func getGourmetData() async throws -> RestaurantResponse{
//        let urlString = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=863a73a43b3ef2b6&large_area=Z011"
//        guard let url = URL(string: urlString) else {throw URLError(.badURL)}
//
//        let (data, response) = try await URLSession.shared.data(from: url)
//        guard let httpRespons = response as? HTTPURLResponse, httpRespons.statusCode == 200 else {throw URLError(.badServerResponse)}
//        let decodeData = try JSONDecoder().decode(RestaurantResponse.self, from: data)
//        return decodeData
//    }
//}
