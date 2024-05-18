//
//  APIError.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/12/24.
//

import Foundation

public enum APIError :Error{
    case urlIsInvalid
    case responseIsNotExpected
    case requestIsInvalid(_ statusCode: Int)
    case serverIsNotResponding(_ statusCode: Int)
    case responseIsUnsuccessful(_ statusCode: Int)
}

public extension APIError{
    init?(httpResponse: HTTPURLResponse?){
        guard let httpResponse else{
            self = APIError.responseIsNotExpected 
            return
        }
        //API要請に対する成功失敗の有無を知らせるステータスコードが含まれている
        switch httpResponse.statusCode{
        case 200..<300:
            return nil
        case 400..<500:
            self = APIError.requestIsInvalid(httpResponse.statusCode)
        case 500..<600:
            self = APIError.serverIsNotResponding(httpResponse.statusCode)
        default:
            self = APIError.responseIsUnsuccessful(httpResponse.statusCode)
        }
    }
}

