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
            let station_name: String
            let intro : String
            let budget: Budget
            
            struct Photo: Codable{
                let pc : PC
                
                struct PC :Codable{
                    let m : String
                }
            }
           
            struct Budget :Codable{
                let name : String
            }
            
            enum CodingKeys: String, CodingKey {
                case id, photo, name, station_name, budget
                case intro = "catch"
            }
        }
    }
}
