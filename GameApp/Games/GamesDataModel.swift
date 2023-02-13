//
//  GamesDataModel.swift
//  GameApp
//
//  Created by David Klaric on 04.02.2023..
//

import Foundation

struct Game: Decodable {
    let count: Int
    let results: [GameResults]
}

struct GameResults: Decodable {
    let id: Int
    let name: String
    let background_image: String
}
