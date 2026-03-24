//
//  MovieCardView.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/23/26.
//

import SwiftUI

struct MovieCardView: View {

    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            posterImage

            Text(movie.title)
                .font(.caption.weight(.semibold))
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(height: 34)
        }
    }

    private var posterImage: some View {
        Group {
            if let url = movie.posterURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Color.gray.opacity(0.2)
                    default:
                        ProgressView()
                    }
                }
            } else {
                Color.gray.opacity(0.2)
            }
        }
        .frame(height: 200)
        .clipped()
        .cornerRadius(12)
    }
}
