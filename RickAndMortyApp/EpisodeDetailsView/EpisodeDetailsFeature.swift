//
//  EpisodeDetailsReducer.swift
//  RickAndMortyApp
//
//  Created by Roman on 17/03/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EpisodeDetailsFeature {
    @Dependency(\.apiClient) var apiClient

    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
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
        case alert(PresentationAction<Alert>)
        case showErrorAlert(Error)
        
        enum Alert: Equatable {
            case confirmError
        }
    }

    var body: some ReducerOf<EpisodeDetailsFeature> {
        Reduce { state, action in
            switch action {
            case .fetchEpisode:
                let episodeNumber = state.episodeNumber
                return .run { send in
                    let episode = try await self.apiClient.fetchEpisodeDetails(episodeNumber)
                    await send(.episodeFetched(episode))
                } catch: { error, send in
                    await send(.showErrorAlert(error))
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
                    await send(.showErrorAlert(error))
                }

            case let .charactersFetched(characters):
                state.characters = characters
                return .none
            case let .showErrorAlert(error):
                state.alert = AlertState(title: {
                    TextState("Error")
                }, actions: {
                    ButtonState(role: .cancel, action: .confirmError ) {
                                TextState("Ok")
                              }
                }, message: {
                    TextState(error.localizedDescription)
                })
                return .none
            case .alert(.presented(.confirmError)):
                return .none
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
