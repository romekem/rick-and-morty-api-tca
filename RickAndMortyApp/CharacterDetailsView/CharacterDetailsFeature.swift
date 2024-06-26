//
//  CharacterDetailsFeature.swift
//  RickAndMortyApp
//
//  Created by Roman on 17/03/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CharacterDetailsFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var episodeDetails: EpisodeDetailsFeature.State?
        var character: Character
        var episodes: [Int] = []
        
        init(character: Character) {
            self.character = character
        }
    }
    
    enum Action {
        case prepareEpisodes
        case showEpisodeButtonTapped(Int)
        case episodeDetails(PresentationAction<EpisodeDetailsFeature.Action>)
    }
    
    var body: some ReducerOf<CharacterDetailsFeature> {
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
                state.episodeDetails = EpisodeDetailsFeature.State(episodeNumber: episodeNumber)
                return .none
            case .episodeDetails:
                return .none
            }
        }
        .ifLet(\.$episodeDetails, action: \.episodeDetails) {
            EpisodeDetailsFeature()
        }
    }
}
