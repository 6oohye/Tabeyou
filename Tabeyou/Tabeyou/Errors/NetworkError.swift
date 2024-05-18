//
//  NetworkError.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/12/24.
//

import Foundation

public enum NetworkError: Error {
    case urlIsInvalid
    case responseIsNotExpected
    case requestIsInvalid(statusCode: Int)
    case serverIsNotResponding(statusCode: Int)
    case responseIsUnsuccessful(statusCode: Int)
    case unknownError
}
