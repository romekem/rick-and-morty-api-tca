//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Roman on 17/03/2024.
//

import Foundation

struct CharactersResult: Codable {
    let results: [Character]
}
struct Character: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Location: Codable {
    let name: String
    let url: String
}
