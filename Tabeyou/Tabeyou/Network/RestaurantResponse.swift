//
//  HomeRestaurantResponse.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/12/24.
//

import Foundation

struct RestaurantResponse : Decodable{
    let shop : [Shop]
}

struct Shop : Decodable {
    let id : String
    let logo_image : String
    let name : String
    let station_name : String
    let open : String
    let budget : [Budget]
}

struct Budget : Decodable{
    let name : String
}
