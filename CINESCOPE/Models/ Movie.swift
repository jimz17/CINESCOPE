//
//   Movie.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/11/26.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String?
    let poster_path: String?
    let vote_average: Double
    let release_date: String?
}
