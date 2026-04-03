//
//  ContentView.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/23/26.
//

import SwiftUI

struct ContentView: View {

    let onLogout: () -> Void

    @StateObject private var viewModel = MovieViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        TabView {

            NavigationStack {
                exploreScreen
                    .navigationTitle("CineScope")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Logout") {
                                onLogout()
                            }
                        }

                        ToolbarItem(placement: .topBarTrailing) {
                            if !viewModel.searchText.isEmpty {
                                Button("Clear") {
                                    Task {
                                        await viewModel.clearSearch()
                                    }
                                }
                            }
                        }
                    }
            }
            .tabItem {
                Label("Explore", systemImage: "film")
            }

            NavigationStack {
                BookmarksView(viewModel: viewModel)
            }
            .tabItem {
                Label("Bookmarks", systemImage: "bookmark.fill")
            }

            NavigationStack {
                BattleView(viewModel: viewModel)
                    .navigationTitle("Scene Battle")
            }
            .tabItem {
                Label("Scene Battle", systemImage: "flame.fill")
            }
        }
    }

    private var exploreScreen: some View {
        VStack(spacing: 12) {

            searchControls

            if viewModel.isLoading {
                Spacer()
                ProgressView("Loading...")
                Spacer()

            } else if let error = viewModel.errorMessage {
                Spacer()
                ContentUnavailableView(
                    "Could not load movies",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )
                .padding()
                Spacer()

            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.movies) { movie in
                            ZStack(alignment: .topTrailing) {
                                NavigationLink {
                                    MovieDetailView(movie: movie, viewModel: viewModel)
                                } label: {
                                    MovieCardView(movie: movie)
                                        .foregroundStyle(.primary)
                                }
                                .buttonStyle(.plain)

                                BookmarkHeartButton(
                                    isBookmarked: viewModel.isBookmarked(movie)
                                ) {
                                    Task {
                                        await viewModel.toggleBookmark(movie)
                                    }
                                }
                                .padding(8)
                                .zIndex(2)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                }
                .refreshable {
                    await viewModel.loadTrending()
                    await viewModel.loadBookmarks()
                }
            }
        }
        .task {
            await viewModel.loadTrending()
            await viewModel.loadBookmarks()
        }
    }

    private var searchControls: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Search movies...", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    Task {
                        await viewModel.search()
                    }
                }

            HStack {
                Button("Search") {
                    Task {
                        await viewModel.search()
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("Clear") {
                    Task {
                        await viewModel.clearSearch()
                    }
                }
                .buttonStyle(.bordered)
            }

            if !viewModel.searchText.isEmpty {
                Text("Press Search or Return to filter. Use Clear to return to trending movies.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

#Preview {
    ContentView(onLogout: {})
}
