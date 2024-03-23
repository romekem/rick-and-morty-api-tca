//
//  EpisodeDetailsReducer.swift
//  RickAndMortyApp
//
//  Created by REDGE on 17/03/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EpisodeDetailsReducer {
    @Dependency(\.apiClient) var apiClient

    @ObservableState
    struct State {
        var episodeNumber: Int
        var episode: Episode?
        var characters: [Character] = []

        init(episodeNumber: Int) {
            self.episodeNumber = episodeNumber
        }
    }

    enum Action {
        case fetchEpisode
        case episodeFetched(Episode?)
        case fetchCharacters([String])
        case charactersFetched([Character])
    }

    var body: some ReducerOf<EpisodeDetailsReducer> {
        Reduce { state, action in
            switch action {
            case .fetchEpisode:
                let episodeNumber = state.episodeNumber
                return .run { send in
                    let episode = try await self.apiClient.fetchEpisodeDetails(episodeNumber)
                    await send(.episodeFetched(episode))
                } catch: { error, send in
                    print("Error \(error)")
                }

            case let .episodeFetched(episode):
                state.episode = episode
                if let episode {
                    return .send(.fetchCharacters(episode.characters))
                } else {
                    return .none
                }
            case let .fetchCharacters(urls):
                return .run { send in
                    let characters = try await self.apiClient.fetchCharacters(urls)
                    await send(.charactersFetched(characters))
                } catch: { error, send in
                    print("Error \(error)")
                }

            case let .charactersFetched(characters):
                state.characters = characters
                return .none
            }
        }
    }
}
