//
//  NetworkService.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/12/24.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case responseError
    case decodeError
    case serverError(statusCode: Int)
    case unknownError
}

class NetworkService {
    static let shared : NetworkService = NetworkService(key: "")
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
            throw NetworkError.urlError
        }
        
        // Query Items
        var finalQueryItems = [URLQueryItem(name: "key", value: key)]
        if let queryItems = queryItems {
            finalQueryItems.append(contentsOf: queryItems)
        }
        components.queryItems = finalQueryItems
        
        guard let url = components.url else {
            throw NetworkError.urlError
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        // URLSession Data
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        
        // HTTP URL Response
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw NetworkError.responseError
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            // Decoding
            do {
                let output = try JSONDecoder().decode(Response.self, from: data)
                return output
            } catch {
                throw NetworkError.decodeError
            }
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
    //MARK: -　グルメサーチAPIを活用してレストランの詳細情報を取得する機能
    func getRestaurantData(range: Int) async throws -> Restaurant.Results {
        do {
            let data: Restaurant = try await fetch(
                path: "gourmet/v1/",
                httpMethod: .get,
                queryItems: [
                    URLQueryItem(name: "key", value: key),
                    URLQueryItem(name: "lat", value: "35.663516524722596"),
                    URLQueryItem(name: "lng", value: "139.7359178448177"),
                    URLQueryItem(name: "range", value: "\(range)"),
                    URLQueryItem(name: "format", value: "json")
                ]
            )
            return data.results
        } catch {
            throw error
        }
    }
    
}
