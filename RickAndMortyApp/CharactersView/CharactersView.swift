//
//  CharactersView.swift
//  RickAndMortyApp
//
//  Created by Roman on 17/03/2024.
//

import SwiftUI
import ComposableArchitecture
import NukeUI

struct CharactersView: View {
    private enum Layout {
        static let imageSize: CGFloat = 80
    }

    let store: StoreOf<CharactersFeature>
    @ObservedObject private var viewStore: ViewStoreOf<CharactersFeature>

    init(store: StoreOf<CharactersFeature>) {
         self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }

    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            List {
                ForEach(viewStore.characters, id: \.id) { character in
                    NavigationLink(state: CharacterDetailsFeature.State(character: character)) {
                        HStack {
                            LazyImage(url: URL(string: character.image)) { state in
                                if let image = state.image {
                                    image.resizable().frame(width: Layout.imageSize, height: Layout.imageSize, alignment: .center)
                                }
                            }
                            Text(character.name)
                        }
                    }
                }
            }
            .navigationTitle("Characters")
            .onAppear(perform: {
                store.send(.fetchCharacters)
            })
        } destination: { store in
            CharacterDetailsView(store: store)
        }
    }
}
