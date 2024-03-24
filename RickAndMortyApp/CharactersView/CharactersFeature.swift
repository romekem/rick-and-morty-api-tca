//
//  CharactersFeature.swift
//  RickAndMortyApp
//
//  Created by Roman on 17/03/2024.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct CharactersFeature {
    @Dependency(\.apiClient) var apiClient

    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var characters: [Character] = []
        var path = StackState<CharacterDetailsFeature.State>()
    }

    enum Action {
        case fetchCharacters
        case characterFetched([Character])
        case path(StackAction<CharacterDetailsFeature.State, CharacterDetailsFeature.Action>)
        case alert(PresentationAction<Alert>)
        case showErrorAlert(Error)
        
        enum Alert: Equatable {
            case confirmError
        }
    }

    var body: some ReducerOf<CharactersFeature> {
        Reduce { state, action in
            switch action {
            case .fetchCharacters:
                return .run { send in
                    let characters = try await self.apiClient.fetchAllCharacters()
                    await send(.characterFetched(characters))
                } catch: { error, send in
                    await send(.showErrorAlert(error))
                }
            case let .characterFetched(characters):
                state.characters = characters
                return .none
            case .path:
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
        .forEach(\.path, action: \.path) {
            CharacterDetailsFeature()
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
