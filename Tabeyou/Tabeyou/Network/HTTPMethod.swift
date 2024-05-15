//
//  HTTPMethod.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/12/24.
//

import Foundation

enum HTTPMethod :String{
    case get
    
    var capitalizedValue : String{
        self.rawValue.capitalized  //.get -> "GET"
    }
}
