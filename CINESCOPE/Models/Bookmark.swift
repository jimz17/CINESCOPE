//
//  Bookmark.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 4/3/26.
//

import Foundation

struct BookmarkRow: Codable, Identifiable {
    let id: Int
    let movieID: Int
    let movieTitle: String

    enum CodingKeys: String, CodingKey {
        case id
        case movieID = "movie_id"
        case movieTitle = "movie_title"
    }
}

struct BookmarkInsert: Codable {
    let userID: UUID
    let movieID: Int
    let movieTitle: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case movieID = "movie_id"
        case movieTitle = "movie_title"
    }
}
