//
//  CharacterDetailsReducer.swift
//  RickAndMortyApp
//
//  Created by Roman on 17/03/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CharacterDetailsReducer {
    @ObservableState
    struct State: Equatable {
        static func == (lhs: CharacterDetailsReducer.State, rhs: CharacterDetailsReducer.State) -> Bool {
            lhs.character.name == rhs.character.name
        }
        
        @Presents var episodeDetails: EpisodeDetailsReducer.State?
        var character: Character
        var episodes: [Int] = []
        
        init(character: Character) {
            self.character = character
        }
    }
    
    enum Action {
        case prepareEpisodes
        case showEpisodeButtonTapped(Int)
        case episodeDetails(PresentationAction<EpisodeDetailsReducer.Action>)
    }
    
    var body: some ReducerOf<CharacterDetailsReducer> {
        Reduce { state, action in
            switch action {
            case .prepareEpisodes:
                let numbers = state.character.episode.compactMap {
                    let url = URL(string: $0)
                    let number = Int(url?.lastPathComponent ?? "")
                    return number
                }
                state.episodes = numbers
                return .none
            case let .showEpisodeButtonTapped(episodeNumber):
                state.episodeDetails = EpisodeDetailsReducer.State(episodeNumber: episodeNumber)
                return .none
            case .episodeDetails:
                return .none
            }
        }
        .ifLet(\.$episodeDetails, action: \.episodeDetails) {
            EpisodeDetailsReducer()
        }
    }
}
