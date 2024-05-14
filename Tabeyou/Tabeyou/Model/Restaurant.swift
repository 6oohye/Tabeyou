//
//  Restaurant.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/12/24.
//

import Foundation

struct Restaurant: Codable {
    let results: Results
    
    struct Results: Codable {
        let shop: [Shop]
        
        struct Shop: Codable {
            let id: String
            let photo: Photo
            let name: String
            let name_kana : String
            let address : String
            let station_name: String
            let lat : Int
            let lng : Int
            let intro : String
            let access :String
            let budget: Budget
            let genre : Genre
            let open : String
            let close : String
            
            struct Photo: Codable{
                let pc : PC
                
                struct PC :Codable{
                    let m : String
                }
            }
            
            struct Budget :Codable{
                let name : String
            }
            
            struct Genre : Codable{
                let name : String
            }
            
            enum CodingKeys: String, CodingKey {
                case id, photo, name, name_kana, address, station_name, lat, lng, access, budget, genre, open, close
                case intro = "catch"
            }
        }
    }
}
