//
//  ContentView.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/23/26.
//

import SwiftUI

struct ContentView: View {

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
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else if let error = viewModel.errorMessage {
                ContentUnavailableView(
                    "Could not load movies",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )
                .padding()

            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.movies) { movie in
                            ZStack(alignment: .topTrailing) {

                                NavigationLink {
                                    MovieDetailView(movie: movie)
                                } label: {
                                    MovieCardView(movie: movie)
                                        .foregroundStyle(.primary)
                                }
                                .buttonStyle(.plain)

                                Button {
                                    viewModel.toggleFavorite(movie)
                                } label: {
                                    Image(systemName: viewModel.isFavorite(movie) ? "heart.fill" : "heart")
                                        .foregroundColor(.red)
                                        .padding(8)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Circle())
                                }
                                .padding(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                }
                .refreshable {
                    await viewModel.loadTrending()
                }
            }
        }
        .task {
            await viewModel.loadTrending()
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
    ContentView()
}
