//
//  VideoResponse.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/11/26.
//

import Foundation

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable {
    let key: String
    let site: String
    let type: String
}
