//
//  BookmarksView.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 4/3/26.
//

import SwiftUI

struct BookmarksView: View {

    @ObservedObject var viewModel: MovieViewModel
    @State private var selectedMovie: Movie?

    var body: some View {
        Group {
            if viewModel.bookmarkRows.isEmpty {
                ContentUnavailableView(
                    "No bookmarks yet",
                    systemImage: "bookmark",
                    description: Text("Tap the heart on a movie to save it here.")
                )
                .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {

                        header

                        VStack(spacing: 12) {
                            ForEach(viewModel.bookmarkRows) { row in
                                bookmarkCard(row)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
                .refreshable {
                    await viewModel.loadBookmarks()
                }
            }
        }
        .navigationTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(item: $selectedMovie) { movie in
            MovieDetailView(movie: movie, viewModel: viewModel)
        }
        .task {
            await viewModel.loadBookmarks()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Saved for later")
                .font(.title2.bold())

            Text("\(viewModel.bookmarkRows.count) bookmarked movie\(viewModel.bookmarkRows.count == 1 ? "" : "s")")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 4)
    }

    private func bookmarkCard(_ row: BookmarkRow) -> some View {
        Button {
            Task {
                do {
                    let movie = try await TMDBService.fetchMovie(id: row.movieID)
                    selectedMovie = movie
                } catch {
                    print("Fetch movie error:", error)
                }
            }
        } label: {
            HStack(spacing: 14) {

                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.18), Color.purple.opacity(0.12)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)

                    Image(systemName: "bookmark.fill")
                        .font(.title3)
                        .foregroundStyle(.blue)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(row.movieTitle)
                        .font(.headline)
                        .lineLimit(2)

                    Text("Tap to view details")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        BookmarksView(viewModel: MovieViewModel())
    }
}
