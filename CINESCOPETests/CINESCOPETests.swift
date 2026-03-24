//
//  CINESCOPETests.swift
//  CINESCOPETests
//
//  Created by Jimmy Aguilar on 3/23/26.
//

import Foundation
import Testing
@testable import CINESCOPE

struct MovieModelTests {

    @Test func posterURLBuildsExpectedTMDBURL() {
        let movie = makeMovie(posterPath: "/abc123.jpg")

        #expect(
            movie.posterURL?.absoluteString
            == "https://image.tmdb.org/t/p/w500/abc123.jpg"
        )
    }

    @Test func posterURLIsNilWhenMissing() {
        let movie = makeMovie(posterPath: nil)
        #expect(movie.posterURL == nil)
    }

    @Test func formattedReleaseDateFallsBackToUnknown() {
        let movie = makeMovie(releaseDate: nil)
        #expect(movie.formattedReleaseDate == "Unknown")
    }
}

struct MovieViewModelTests {

    @MainActor
    @Test func generateBattleCreatesTwoDifferentMovies() throws {
        let viewModel = MovieViewModel()
        viewModel.movies = [
            makeMovie(id: 1),
            makeMovie(id: 2),
            makeMovie(id: 3)
        ]

        viewModel.generateBattle()

        let pair = try #require(viewModel.battlePair)

        #expect(pair.0.id != pair.1.id)
    }

    @MainActor
    @Test func selectWinnerStoresWinner() throws {
        let viewModel = MovieViewModel()
        viewModel.movies = [
            makeMovie(id: 1),
            makeMovie(id: 2)
        ]

        viewModel.generateBattle()
        let pair = try #require(viewModel.battlePair)

        viewModel.selectWinner(pair.0)

        #expect(viewModel.battleWinner?.id == pair.0.id)
    }

    @MainActor
    @Test func toggleFavoriteAddsAndRemovesMovie() {
        let viewModel = MovieViewModel()
        let movie = makeMovie(id: 99)

        viewModel.toggleFavorite(movie)
        #expect(viewModel.isFavorite(movie) == true)

        viewModel.toggleFavorite(movie)
        #expect(viewModel.isFavorite(movie) == false)
    }
}

private func makeMovie(
    id: Int = 1,
    title: String = "Test Movie",
    overview: String? = "Overview",
    posterPath: String? = "/test.jpg",
    voteAverage: Double = 7.5,
    releaseDate: String? = "2026-01-01"
) -> Movie {
    Movie(
        id: id,
        title: title,
        overview: overview,
        poster_path: posterPath,
        vote_average: voteAverage,
        release_date: releaseDate
    )
}
