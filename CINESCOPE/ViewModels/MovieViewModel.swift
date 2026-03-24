//
//  MovieViewModel.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/23/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class MovieViewModel: ObservableObject {

    @Published var movies: [Movie] = []
    @Published var favorites: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""

    @Published var battlePair: (Movie, Movie)?
    @Published var battleWinner: Movie?

    func loadTrending() async {
        isLoading = true
        errorMessage = nil

        do {
            movies = try await TMDBService.fetchTrending()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func search() async {
        guard !searchText.isEmpty else {
            await loadTrending()
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            movies = try await TMDBService.searchMovies(query: searchText)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func clearSearch() async {
        searchText = ""
        await loadTrending()
    }

    func toggleFavorite(_ movie: Movie) {
        if favorites.contains(where: { $0.id == movie.id }) {
            favorites.removeAll { $0.id == movie.id }
        } else {
            favorites.append(movie)
        }
    }

    func isFavorite(_ movie: Movie) -> Bool {
        favorites.contains(where: { $0.id == movie.id })
    }

    func generateBattle() {
        guard movies.count >= 2 else {
            battlePair = nil
            battleWinner = nil
            return
        }

        let shuffled = movies.shuffled()
        battlePair = (shuffled[0], shuffled[1])
        battleWinner = nil
    }

    func selectWinner(_ movie: Movie) {
        battleWinner = movie
    }
}
