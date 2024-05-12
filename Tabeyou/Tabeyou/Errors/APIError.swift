//
//  APIError.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/12/24.
//

import Foundation

public enum APIError :Error{
    case urlIsInvalid
    case responseIsNotExpected
    case requestIsInvalid(_ statusCode: Int)
    case serverIsNotResponding(_ statusCode: Int)
    case responseIsUnsuccessful(_ statusCode: Int)
}

extension APIError{
    init?(httpResponse: HTTPURLResponse?){
        guard let httpResponse else{
            self = APIError.responseIsNotExpected//error
            return
        }
        //HTTPResponse에는 요청에 대한 성공실패 여부를 알려주는 스테이터스 코드가 담겨있음
        //StatusCode는 100번부터 500번대 까지 있는데
        //100번대 : 서버가 요청을 받았으나 프로세스를 계속 진행하라는 정보에 대한 코드
        //200번대 : 요청에 성공했으며 요청에 대한 응답이 반환되었다는 코드
        //300번대 : 요청 완료를 위해 추가적인 작업조치가 필요하다는 리다이렉션 코드
        //400번대 : 요청이 잘못되었다는 오류
        //500번대 : 요청은 유효하지만 서버가 처리하지 못했다는 서버오류
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

