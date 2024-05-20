//
//  NetworkService.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/12/24.
//

import Foundation

class NetworkService {
    static let shared: NetworkService = NetworkService(key: "")
    private let hostURL = "https://webservice.recruit.co.jp/hotpepper"
    let key: String
    
    init(key: String) {
        self.key = key
    }
    
    func fetch<Response: Decodable>(
        path: String,
        httpMethod: HTTPMethod,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> Response {
        // URLRequest
        guard var components = URLComponents(string: "\(hostURL)/\(path)") else {
            throw NetworkError.urlIsInvalid
        }
        
        // Query Items
        var finalQueryItems = [URLQueryItem(name: "key", value: key)]
        if let queryItems = queryItems {
            finalQueryItems.append(contentsOf: queryItems)
        }
        components.queryItems = finalQueryItems
        
        guard let url = components.url else {
            throw NetworkError.urlIsInvalid
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        // URLSession Data
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        
        // HTTP URL Response
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                    continuation.resume(throwing: NetworkError.responseIsNotExpected)
                    return
                }
                
                switch httpResponse.statusCode {
                case 200..<300:
                    do {
                        let output = try JSONDecoder().decode(Response.self, from: data)
                        continuation.resume(returning: output)
                    } catch {
                        continuation.resume(throwing: NetworkError.unknownError)
                    }
                case 400..<500:
                    continuation.resume(throwing: NetworkError.requestIsInvalid(statusCode: httpResponse.statusCode))
                case 500..<600:
                    continuation.resume(throwing: NetworkError.serverIsNotResponding(statusCode: httpResponse.statusCode))
                default:
                    continuation.resume(throwing: NetworkError.responseIsUnsuccessful(statusCode: httpResponse.statusCode))
                }
            }.resume()
        }
    }
    
    //MARK: - グルメサーチAPIを活用してレストランリストを取得する
    func getRestaurantData(range: Int, start: Int, page: Int) async throws -> Restaurant.Results {
        do {
            let data: Restaurant = try await fetch(
                path: "gourmet/v1/",
                httpMethod: .get,
                queryItems: [
                    URLQueryItem(name: "key", value: key),
                    URLQueryItem(name: "lat", value: "34.705867155529965"),
                    URLQueryItem(name: "lng", value: "135.49487806407137"),
                    URLQueryItem(name: "range", value: "\(range)"),
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "start", value: "\(start)"),
                    URLQueryItem(name: "format", value: "json")
                ]
            )
            return data.results
        } catch {
            throw error
        }
    }
    
    //MARK: - レストランの詳細情報を取得するためにIDを取得する
    func getRestaurantDetailData(restaurantID: String) async throws -> Restaurant.Results {
        do {
            let data: Restaurant = try await fetch(
                path: "gourmet/v1/",
                httpMethod: .get,
                queryItems: [
                    URLQueryItem(name: "key", value: key),
                    URLQueryItem(name: "id", value: restaurantID),
                    URLQueryItem(name: "format", value: "json")
                ]
            )
            return data.results
        } catch {
            throw error
        }
    }
}
