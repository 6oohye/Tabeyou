//
//  URLRequest.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/12/24.
//

import Foundation

extension URLRequest{
    init(
        urlString : String,
        httpMethod : HTTPMethod,
        key : String,
        queryItems : [URLQueryItem]?
    ) throws {
        //URL Components
        guard var components = URLComponents(string: urlString)else{
            throw APIError.urlIsInvalid //error
        }
        
        //Query Item
        components.queryItems = [URLQueryItem(name: "key", value: key)]
        if let queryItems{
            components.queryItems?.append(contentsOf: queryItems)
        }
        
        //URL Request
        guard let url = components.url else{
            throw APIError.urlIsInvalid
        }
        self.init(url: url)
        
        //HTTPMEthod
        self.httpMethod = httpMethod.capitalizedValue
    }
}
