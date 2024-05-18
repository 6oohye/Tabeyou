//
//  Restaurant.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/12/24.
//

import Foundation

struct Restaurant: Codable {
    let results: Results
    
    struct Results: Codable {
        let results_available :Int //全体の結果の数を取得し、距離ごとに店がどれくらいあるかを確認します。
        let shop: [Shop]
        
        //shopで必要な結果を持ってきました。
        struct Shop: Codable {
            let id: String
            let photo: Photo
            let name: String
            let name_kana : String
            let address : String
            let station_name: String
            let lat : Double
            let lng : Double
            let intro : String
            let access : String
            let open : String
            let close : String
            let budget: Budget
            let genre : Genre
            
            struct Photo: Codable{
                let pc : PC
                
                struct PC :Codable{
                    let m : String
                    let l : String
                }
            }
            
            struct Budget :Codable{
                let name : String
            }
            struct Genre : Codable{
                let name : String
            }
            
            enum CodingKeys: String, CodingKey {
                case id, photo, name, station_name, budget, name_kana, address, lat, lng, access, open, close, genre
                case intro = "catch"
            }
        }
    }
}
