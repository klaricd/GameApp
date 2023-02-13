//
//  DataModel.swift
//  GameApp
//
//  Created by David Klaric on 03.02.2023..
//

import Foundation

struct Genre: Decodable {
    let count: Int
    let results: [GenresResults]
}

struct GenresResults: Decodable {
    let id: Int
    let name: String
    let games_count: Int
    let image_background: String
}
