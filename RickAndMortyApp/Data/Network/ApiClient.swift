//
//  ApiService.swift
//  RickAndMortyApp
//
//  Created by Roman on 17/03/2024.
//

import ComposableArchitecture
import Foundation

struct ApiClient {
    var fetchAllCharacters: () async throws -> [Character]
    var fetchCharacters: ([String]) async throws -> [Character]
    var fetchEpisodeDetails: (Int) async throws -> Episode?
}

extension ApiClient: DependencyKey {
    static let liveValue: ApiClient = Self(
        fetchAllCharacters: {
            guard let url = URL(string: ApiUrls.characters.url) else { return [] }
            let result: CharactersResult = try await request(url: url)
            return result.results
        }, fetchCharacters: { urls in
            let characters: [Character?] = try await arrayRequest(for: urls)
            return characters.compactMap({ $0 })
        }, fetchEpisodeDetails: { episodeNumber in
            guard let url = URL(string: ApiUrls.episode(episodeNumber).url) else { return nil }
            let episode: Episode = try await request(url: url)
            return episode
        })
}

extension DependencyValues {
    var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}

extension ApiClient {
    static private func request<T: Codable>(url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    }

    private static func arrayRequest<T: Codable>(for links: [String]) async throws -> [T?] {
        let results: [T?] = try await withThrowingTaskGroup(of: T?.self) { group in
            for link in links {
                group.addTask {
                    do {
                        guard let linkURL = URL(string: link) else { return nil }
                        let (data, _) = try await URLSession.shared.data(from: linkURL)
                        let model = try JSONDecoder().decode(T.self, from: data)
                        return model
                    } catch {
                        print("Error fetching or decoding data from \(link): \(error)")
                        return nil
                    }
                }
            }
            return try await group.reduce(into: [T?]()) { models, model in
                models.append(model)
            }
        }
        return results
    }
}
