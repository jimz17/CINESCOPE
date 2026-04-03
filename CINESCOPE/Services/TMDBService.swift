//
//  TMDBService.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 3/23/26.
//
import Foundation

struct TMDBService {

    private static let apiKey = "9ae4842941cb307c048e4cf7fa9cd3e1"
    private static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    private static let decoder = JSONDecoder()

    enum ServiceError: Error {
            case invalidURL
            case badStatusCode(Int)
        }

        private static func fetch<T: Decodable>(
            path: String,
            queryItems: [URLQueryItem] = []
        ) async throws -> T {

            var components = URLComponents(
                url: baseURL.appendingPathComponent(path),
                resolvingAgainstBaseURL: false
            )
            components?.queryItems = queryItems + [
                URLQueryItem(name: "api_key", value: apiKey)
            ]

            guard let url = components?.url else {
                throw ServiceError.invalidURL
            }

            let (data, response) = try await URLSession.shared.data(from: url)

            guard let http = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            guard 200..<300 ~= http.statusCode else {
                print("TMDB error status:", http.statusCode)
                print("Response body:", String(data: data, encoding: .utf8) ?? "No body")
                throw ServiceError.badStatusCode(http.statusCode)
            }

            return try decoder.decode(T.self, from: data)
        }

        static func fetchTrending() async throws -> [Movie] {
            let response: MovieResponse = try await fetch(path: "trending/movie/week")
            return response.results
        }

        static func searchMovies(query: String) async throws -> [Movie] {
            let response: MovieResponse = try await fetch(
                path: "search/movie",
                queryItems: [
                    URLQueryItem(name: "query", value: query)
                ]
            )
            return response.results
        }

        static func fetchTrailer(for movieID: Int) async throws -> String? {
            let response: VideoResponse = try await fetch(path: "movie/\(movieID)/videos")
            return response.results.first(where: {
                $0.site == "YouTube" && $0.type == "Trailer"
            })?.key
        }

        static func fetchMovie(id: Int) async throws -> Movie {
            try await fetch(path: "movie/\(id)")
        }
    }
