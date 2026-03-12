//
//  Movie+Computed.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/11/26.
//

import Foundation

extension Movie {

    var posterURL: URL? {
        guard let poster_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(poster_path)")
    }

    var formattedReleaseDate: String {
        release_date ?? "Unknown"
    }
}
