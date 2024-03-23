//
//  ApiUrls.swift
//  RickAndMortyApp
//
//  Created by REDGE on 18/03/2024.
//

import Foundation

enum ApiUrls {
    case characters
    case episode(Int)

    var url: String {
        switch self {
        case .characters:
            ApiConstants.host + "/api/character"
        case let .episode(number):
            ApiConstants.host + "/api/episode/\(number)"
        }
    }
}

enum ApiConstants {
    static let host = "https://rickandmortyapi.com"
}
