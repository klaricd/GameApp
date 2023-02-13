//
//  DetailsDataModel.swift
//  GameApp
//
//  Created by David Klaric on 08.02.2023..
//

import Foundation

struct Detail: Decodable {
    let id: Int
    let name: String
    let description: String
    let released: String
    let rating: Double
    let website: String
    let movies_count: Int
}
