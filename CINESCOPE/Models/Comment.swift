//
//  Comment.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 4/3/26.
//

import Foundation

struct CommentRow: Codable, Identifiable {
    let id: Int
    let movieID: Int
    let body: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case movieID = "movie_id"
        case body
        case createdAt = "created_at"
    }
}

struct CommentInsert: Codable {
    let userID: UUID
    let movieID: Int
    let body: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case movieID = "movie_id"
        case body
    }
}
