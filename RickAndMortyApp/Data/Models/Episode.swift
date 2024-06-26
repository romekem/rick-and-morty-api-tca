//
//  Episode.swift
//  RickAndMortyApp
//
//  Created by Roman on 17/03/2024.
//

import Foundation

struct Episode: Codable, Equatable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}
