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
        static func == (lhs: CharactersFeature.State, rhs: CharactersFeature.State) -> Bool {
            lhs.characters.count == rhs.characters.count
        }
        
        var characters: [Character] = []
        var path = StackState<CharacterDetailsFeature.State>()
    }

    enum Action {
        case fetchCharacters
        case characterFetched([Character])
        case path(StackAction<CharacterDetailsFeature.State, CharacterDetailsFeature.Action>)
    }

    var body: some ReducerOf<CharactersFeature> {
        Reduce { state, action in
            switch action {
            case .fetchCharacters:
                return .run { send in
                    let characters = try await self.apiClient.fetchAllCharacters()
                    await send(.characterFetched(characters))
                } catch: { error, send in
                    print("Error: \(error)")
                }
            case let .characterFetched(characters):
                state.characters = characters
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            CharacterDetailsFeature()
        }
    }
}
