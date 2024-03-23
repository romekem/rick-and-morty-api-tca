//
//  CharacterDetailsView.swift
//  RickAndMortyApp
//
//  Created by Roman on 17/03/2024.
//

import SwiftUI
import ComposableArchitecture
import NukeUI

struct CharacterDetailsView: View {
    private enum Layout {
        static let spacing: CGFloat = 10
    }

    @Bindable var store: StoreOf<CharacterDetailsFeature>

    var body: some View {
            ScrollView {
                LazyVStack(spacing: Layout.spacing) {
                    LazyImage(url: URL(string: store.character.image))
                    Text(store.character.name)
                        .textCase(.uppercase)
                        .bold()
                    HStack {
                        Text("gender:")
                        Text(store.character.gender)
                            .bold()
                    }
                    HStack {
                        Text("status:")
                        Text(store.character.status)
                            .bold()
                    }
                    HStack {
                        Text("species:")
                        Text(store.character.species)
                            .bold()
                    }
                    HStack {
                        Text("location:")
                        Text(store.character.location.name)
                            .bold()
                    }
                    LazyVStack(spacing: Layout.spacing) {
                        Text("episodes:")
                        ForEach(store.state.episodes, id: \.self) { episodeNumber in
                            Button(action: {
                                store.send(.showEpisodeButtonTapped(episodeNumber))
                            }, label: {
                                Text("episode \(episodeNumber)")
                                    .bold()
                            })
                        }
                    }
                }
            .onAppear(perform: {
                store.send(.prepareEpisodes)
            })
            .foregroundStyle(.black)
        }
            .sheet(
                  item: $store.scope(state: \.episodeDetails, action: \.episodeDetails)
                ) { store in
                  NavigationStack {
                    EpisodeDetailsView(store: store)
                  }
                }
    }
}
