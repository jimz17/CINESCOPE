//
//  TMDBService.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/11/26.
//

import Foundation

struct TMDBService {

    // MARK: - Configuration

    private static let apiKey = "9ae4842941cb307c048e4cf7fa9cd3e1"
    private static let baseURL = "https://api.themoviedb.org/3"
    
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    // MARK: - Generic Fetch Helper

    private static func fetch<T: Decodable>(from endpoint: String) async throws -> T {
        
        guard let url = URL(string: "\(baseURL)\(endpoint)&api_key=\(apiKey)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode(T.self, from: data)
    }

    // MARK: - Trending

    static func fetchTrending() async throws -> [Movie] {
        
        let endpoint = "/trending/movie/week?"
        let response: MovieResponse = try await fetch(from: endpoint)
        return response.results
    }

    // MARK: - Search

    static func searchMovies(query: String) async throws -> [Movie] {
        
        let encodedQuery = query
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let endpoint = "/search/movie?query=\(encodedQuery)"
        let response: MovieResponse = try await fetch(from: endpoint)
        return response.results
    }

    // MARK: - Trailer

    static func fetchTrailer(for movieID: Int) async throws -> String? {
        
        let endpoint = "/movie/\(movieID)/videos?"
        let response: VideoResponse = try await fetch(from: endpoint)

        return response.results.first(where: {
            $0.site == "YouTube" && $0.type == "Trailer"
        })?.key
    }
}
