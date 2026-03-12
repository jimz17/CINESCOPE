//
//  BattleView.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/11/26.
//

import SwiftUI

struct BattleView: View {

    @ObservedObject var viewModel: MovieViewModel

    @State private var pair: (Movie, Movie)?

    var body: some View {

        VStack(spacing: 24) {

            if let pair {

                Text("Which trailer wins?")
                    .font(.headline)

                HStack(spacing: 16) {

                    battleCard(pair.0)
                    battleCard(pair.1)
                }
            }

            Button("New Battle") {
                pair = viewModel.randomPair()
            }
        }
        .padding()
        .onAppear {
            pair = viewModel.randomPair()
        }
    }

    private func battleCard(_ movie: Movie) -> some View {

        VStack {

            if let url = movie.posterURL {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 200)
                .clipped()
                .cornerRadius(12)
            }

            Text(movie.title)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .onTapGesture {
            print("\(movie.title) wins!")
        }
    }
}
