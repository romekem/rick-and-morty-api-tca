//
//  RickAndMortyAppApp.swift
//  RickAndMortyApp
//
//  Created by Roman on 17/03/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct RickAndMortyApp: App {

    var body: some Scene {
        WindowGroup {
            CharactersView(store: .init(initialState: CharactersReducer.State(), reducer: {
                CharactersReducer()
            }))
        }
    }
}
