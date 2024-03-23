//
//  EpisodeDetailsView.swift
//  RickAndMortyApp
//
//  Created by Roman on 17/03/2024.
//

import SwiftUI
import ComposableArchitecture

struct EpisodeDetailsView: View {
    private enum Layout {
        static let spacing: CGFloat = 10
    }

    @Bindable var store: StoreOf<EpisodeDetailsFeature>

    var body: some View {
        NavigationStack {
            ScrollView {
                if let episode = store.episode {
                    LazyVStack(spacing: Layout.spacing) {
                        HStack(content: {
                            Text("episode: ")
                            Text(episode.episode)
                                .bold()
                            
                        })
                        HStack(content: {
                            Text("name: ")
                            Text(episode.name)
                                .bold()
                        })
                        HStack(content: {
                            Text("tv release: ")
                            Text(episode.airDate)
                                .bold()
                        })
                        Text("apperance:")
                        ForEach(store.characters, id: \.id) { character in
                            Text(character.name)
                                .bold()
                        }
                    }
                }
            }
        }
        .navigationTitle("Episode details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            store.send(.fetchEpisode)
        })
    }
}
