//
//  MovieDetailView.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/23/26.
//


//
//  ContentView.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/23/26.
//
import SwiftUI

struct MovieDetailView: View {

    let movie: Movie
    @ObservedObject var viewModel: MovieViewModel

    @State private var trailerKey: String?
    @State private var isLoadingTrailer = false
    @State private var commentText = ""
    @State private var isPostingComment = false

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

                    HStack(alignment: .top) {
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
                        }

                        Spacer()

                        BookmarkHeartButton(
                            isBookmarked: viewModel.isBookmarked(movie)
                        ) {
                            Task {
                                await viewModel.toggleBookmark(movie)
                            }
                        }
                        .padding(.leading, 8)
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

                commentsSection

                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadDetailData()
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

    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Comments")
                .font(.headline)

            TextField("Write a comment...", text: $commentText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)

            Button {
                Task {
                    isPostingComment = true
                    await viewModel.postComment(movieID: movie.id, text: commentText)
                    commentText = ""
                    isPostingComment = false
                }
            } label: {
                if isPostingComment {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Post Comment")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isPostingComment)

            if viewModel.comments.isEmpty {
                Text("No comments yet.")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.comments) { comment in
                        Text(comment.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }

    private func loadDetailData() async {
        isLoadingTrailer = true
        async let trailerTask = TMDBService.fetchTrailer(for: movie.id)
        async let commentsTask = viewModel.loadComments(movieID: movie.id)

        do {
            trailerKey = try await trailerTask
        } catch {
            trailerKey = nil
            print("Trailer fetch error:", error)
        }

        await commentsTask
        isLoadingTrailer = false
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
            ),
            viewModel: MovieViewModel()
        )
    }
}
