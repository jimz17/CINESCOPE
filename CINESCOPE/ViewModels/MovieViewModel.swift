//
//  MovieViewModeL.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/11/26.
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

    // MARK: Trending

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

    // MARK: Search

    func search() async {

        guard !searchText.isEmpty else {
            await loadTrending()
            return
        }

        isLoading = true

        do {
            movies = try await TMDBService.searchMovies(query: searchText)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: Favorites

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

    // MARK: Scene Battle

    func randomPair() -> (Movie, Movie)? {

        guard movies.count >= 2 else { return nil }

        let shuffled = movies.shuffled()

        return (shuffled[0], shuffled[1])
    }
}
