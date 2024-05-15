//
//  APIClientTest.swift
//  TabeyouTests
//
//  Created by 6혜진 on 5/12/24.
//

import XCTest
@testable import Tabeyou

final class APIClientTest: XCTestCase {
    func test_fetch() async throws {
        struct Response: Codable {
            let results: Results
            
            struct Results: Codable {
                let shop: [Shop]
                
                struct Shop: Codable {
                    let id: String
                    let logo_image: String
                    let name: String
                    let station_name: String
                    let open: String
                    let budget: Budget
                    
                   
                    struct Budget :Codable{
                        let name : String
                    }
                    
                    enum CodingKeys: String, CodingKey {
                        case id, logo_image, name, station_name, open, budget
                    }
                }
            }
        }
        
        let networkService = NetworkService(key: "863a73a43b3ef2b6")
        let response: Response = try await networkService.fetch(
            path: "gourmet/v1/",
            httpMethod: .get,
            queryItems: [
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "large_area", value: "Z011")
            ]
        )
  
        // 테스트에 대한 적절한 assertion 추가
        XCTAssertGreaterThan(response.results.shop.count, 0)
    }
}
