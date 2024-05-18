//
//  HTTPMethod.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/12/24.
//

import Foundation

enum HTTPMethod :String{
    case get
    
    var capitalizedValue : String{
        self.rawValue.capitalized  //.get -> "GET"
    }
}
