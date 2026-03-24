//
//  MovieDetailView.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/23/26.
//

import SwiftUI

struct MovieDetailView: View {

    let movie: Movie

    @State private var trailerKey: String?
    @State private var isLoadingTrailer = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                if let url = movie.posterURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            Color.gray.opacity(0.2)
                        default:
                            ProgressView()
                        }
                    }
                    .frame(height: 360)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(16)
                    .shadow(radius: 8)
                }

                VStack(alignment: .leading, spacing: 12) {

                    Text(movie.title)
                        .font(.title.bold())

                    HStack(spacing: 16) {

                        Text("Release: \(movie.formattedReleaseDate)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)

                            Text(String(format: "%.1f", movie.vote_average))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    if let overview = movie.overview,
                       !overview.isEmpty {
                        Text(overview)
                            .font(.body)
                            .lineSpacing(4)
                    } else {
                        Text("No description available.")
                            .foregroundStyle(.secondary)
                    }
                }

                trailerSection

                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadTrailer()
        }
    }

    private var trailerSection: some View {
        Group {
            if isLoadingTrailer {
                ProgressView("Loading Trailer...")
                    .frame(maxWidth: .infinity)
            } else if let trailerKey,
                      let url = URL(string: "https://www.youtube.com/watch?v=\(trailerKey)") {
                Link(destination: url) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                        Text("Watch Trailer")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                }
            } else if !isLoadingTrailer {
                Text("No trailer available.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func loadTrailer() async {
        isLoadingTrailer = true
        defer { isLoadingTrailer = false }

        do {
            trailerKey = try await TMDBService.fetchTrailer(for: movie.id)
        } catch {
            trailerKey = nil
            print("Trailer fetch error:", error)
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(
            movie: Movie(
                id: 1,
                title: "Preview Movie",
                overview: "This is a preview description.",
                poster_path: nil,
                vote_average: 7.4,
                release_date: "2026-03-23"
            )
        )
    }
}
