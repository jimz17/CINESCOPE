//
//  MovieViewModel.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/23/26.
//

import Foundation
import SwiftUI
import Combine
import Supabase
import Auth
import PostgREST

@MainActor
final class MovieViewModel: ObservableObject {

    @Published var movies: [Movie] = []
    @Published var favorites: [Movie] = []
    @Published var bookmarkRows: [BookmarkRow] = []
    @Published var bookmarkedMovieIDs: [Int] = []
    @Published var comments: [CommentRow] = []

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

    func loadBookmarks() async {
        var user = SupabaseService.shared.client.auth.currentSession?.user

        if user == nil {
            for _ in 0..<10 {
                try? await Task.sleep(nanoseconds: 200_000_000)
                user = SupabaseService.shared.client.auth.currentSession?.user
                if user != nil { break }
            }
        }

        guard let user else {
            bookmarkRows = []
            bookmarkedMovieIDs = []
            return
        }

        do {
            let rows: [BookmarkRow] = try await SupabaseService.shared.client
                .from("bookmarks")
                .select()
                .eq("user_id", value: user.id.uuidString)
                .execute()
                .value

            bookmarkRows = rows
            bookmarkedMovieIDs = rows.map { $0.movieID }
        } catch {
            print("Load bookmarks error:", error)
        }
    }

    func isBookmarked(_ movie: Movie) -> Bool {
        bookmarkedMovieIDs.contains(movie.id)
    }

    func toggleBookmark(_ movie: Movie) async {
        guard let user = SupabaseService.shared.client.auth.currentSession?.user else {
            print("No user logged in")
            return
        }

        let wasBookmarked = bookmarkedMovieIDs.contains(movie.id)

        if wasBookmarked {
            bookmarkedMovieIDs.removeAll { $0 == movie.id }
        } else {
            bookmarkedMovieIDs.append(movie.id)
        }

        do {
            if wasBookmarked {
                try await SupabaseService.shared.client
                    .from("bookmarks")
                    .delete()
                    .eq("user_id", value: user.id.uuidString)
                    .eq("movie_id", value: movie.id)
                    .execute()
            } else {
                let row = BookmarkInsert(
                    userID: user.id,
                    movieID: movie.id,
                    movieTitle: movie.title
                )

                try await SupabaseService.shared.client
                    .from("bookmarks")
                    .insert(row)
                    .execute()
            }

            await loadBookmarks()
        } catch {
            print("Bookmark toggle error:", error)

            if wasBookmarked {
                if !bookmarkedMovieIDs.contains(movie.id) {
                    bookmarkedMovieIDs.append(movie.id)
                }
            } else {
                bookmarkedMovieIDs.removeAll { $0 == movie.id }
            }
        }
    }

    func removeBookmark(movieID: Int) async {
        guard let user = SupabaseService.shared.client.auth.currentSession?.user else {
            print("No user logged in")
            return
        }

        bookmarkedMovieIDs.removeAll { $0 == movieID }
        bookmarkRows.removeAll { $0.movieID == movieID }

        do {
            try await SupabaseService.shared.client
                .from("bookmarks")
                .delete()
                .eq("user_id", value: user.id.uuidString)
                .eq("movie_id", value: movieID)
                .execute()

            await loadBookmarks()
        } catch {
            print("Remove bookmark error:", error)
        }
    }

    func loadComments(movieID: Int) async {
        do {
            let rows: [CommentRow] = try await SupabaseService.shared.client
                .from("comments")
                .select()
                .eq("movie_id", value: movieID)
                .order("created_at", ascending: false)
                .execute()
                .value

            comments = rows
        } catch {
            print("Load comments error:", error)
        }
    }

    func postComment(movieID: Int, text: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        guard let user = SupabaseService.shared.client.auth.currentSession?.user else {
            print("No user logged in")
            return
        }

        do {
            let row = CommentInsert(
                userID: user.id,
                movieID: movieID,
                body: trimmed
            )

            try await SupabaseService.shared.client
                .from("comments")
                .insert(row)
                .execute()

            await loadComments(movieID: movieID)
        } catch {
            print("Post comment error:", error)
        }
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
