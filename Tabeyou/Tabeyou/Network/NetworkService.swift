//
//  NetworkService.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/12/24.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    private let hostURL = "https://webservice.recruit.co.jp/hotpepper"
    private let apiKey: String
        
    private init() {
        guard let key = ProcessInfo.processInfo.environment["API_KEY"] else {
            fatalError("API Key is not set in environment variables")
        }
        self.apiKey = key
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
        var finalQueryItems = [URLQueryItem(name: "key", value: apiKey)]
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
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw NetworkError.responseIsNotExpected
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            // Decoding
            do {
                let output = try JSONDecoder().decode(Response.self, from: data)
                return output
            } catch {
                throw NetworkError.unknownError
            }
        case 400..<500:
            throw NetworkError.requestIsInvalid(statusCode: httpResponse.statusCode)
        case 500..<600:
            throw NetworkError.serverIsNotResponding(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.responseIsUnsuccessful(statusCode: httpResponse.statusCode)
        }
    }
    
    //MARK: - グルメサーチAPIを活用してレストランリストを取得する
    func getRestaurantData(range: Int, start: Int, page: Int, lat: Double, lng: Double) async throws -> Restaurant.Results {
        do {
            let queryItems = [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "range", value: "\(range)"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "start", value: "\(start)"),
                //リストの確認のため、日本、大阪の緯度経度を入れておきました。
                URLQueryItem(name: "lat", value: "34.705867155529965"),
                URLQueryItem(name: "lng", value: "135.49487806407137"),
                URLQueryItem(name: "format", value: "json")
            ]
            print("lat: \(lat), lng: \(lng)")
            
            let data: Restaurant = try await fetch(
                path: "gourmet/v1/",
                httpMethod: .get,
                queryItems: queryItems
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
                    URLQueryItem(name: "key", value: apiKey),
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
