//
//  ContentView.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/11/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = MovieViewModel()

    var body: some View {

        TabView {

            // MARK: Explore Tab
            NavigationStack {

                VStack {

                    // Search Bar
                    TextField("Search movies...", text: $viewModel.searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .onSubmit {
                            Task {
                                await viewModel.search()
                            }
                        }

                    // Loading / Error / Grid
                    Group {

                        if viewModel.isLoading {
                            ProgressView("Loading...")
                                .padding()
                        }

                        else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding()
                        }

                        else {

                            ScrollView {

                                LazyVGrid(
                                    columns: [GridItem(.adaptive(minimum: 140))],
                                    spacing: 16
                                ) {

                                    ForEach(viewModel.movies) { movie in

                                        NavigationLink {
                                            MovieDetailView(movie: movie)
                                        } label: {

                                            VStack {

                                                ZStack(alignment: .topTrailing) {

                                                    if let url = movie.posterURL {
                                                        AsyncImage(url: url) { image in
                                                            image
                                                                .resizable()
                                                                .scaledToFill()
                                                        } placeholder: {
                                                            ProgressView()
                                                        }
                                                        .frame(height: 200)
                                                        .clipped()
                                                        .cornerRadius(12)
                                                    }

                                                    // Favorite Button
                                                    Button {
                                                        viewModel.toggleFavorite(movie)
                                                    } label: {
                                                        Image(systemName:
                                                            viewModel.favorites.contains(where: { $0.id == movie.id })
                                                            ? "heart.fill"
                                                            : "heart"
                                                        )
                                                        .foregroundColor(.red)
                                                        .padding(6)
                                                    }
                                                }

                                                Text(movie.title)
                                                    .font(.caption)
                                                    .multilineTextAlignment(.center)
                                            }
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
                .navigationTitle("CineScope")
                .task {
                    await viewModel.loadTrending()
                }
            }
            .tabItem {
                Label("Explore", systemImage: "film")
            }


            // MARK: Scene Battle Tab
            NavigationStack {
                BattleView(viewModel: viewModel)
            }
            .tabItem {
                Label("Scene Battle", systemImage: "flame.fill")
            }
        }
    }
}

#Preview {
    ContentView()
}
