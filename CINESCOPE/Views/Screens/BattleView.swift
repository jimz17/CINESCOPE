//
//  BattleView.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/23/26.
//

import SwiftUI

struct BattleView: View {

    @ObservedObject var viewModel: MovieViewModel

    var body: some View {
        VStack(spacing: 24) {

            Text("Which trailer wins?")
                .font(.headline)

            if let pair = viewModel.battlePair {

                HStack(spacing: 16) {
                    battleCard(pair.0)
                    battleCard(pair.1)
                }

                if let winner = viewModel.battleWinner {
                    Text("\(winner.title) wins")
                        .font(.headline)
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                }

            } else {
                Text("Not enough movies to battle")
                    .foregroundStyle(.secondary)
            }

            Button("New Battle") {
                viewModel.generateBattle()
            }
        }
        .padding()
        .onAppear {
            viewModel.generateBattle()
        }
    }

    private func battleCard(_ movie: Movie) -> some View {
        MovieCardView(movie: movie)
            .onTapGesture {
                viewModel.selectWinner(movie)
            }
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    BattleView(viewModel: MovieViewModel())
}
