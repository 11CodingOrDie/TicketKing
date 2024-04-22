//
//  MovieService.swift
//  TicketKing
//
//  Created by David Jang on 4/22/24.
//

import Foundation

enum APIError: Error {
    case badURL, requestError, decodingError
}

class MovieManager {
    static let shared = MovieManager()
    private let baseURL = "https://api.themoviedb.org/3/movie/"
    private let apiKey = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMzhkNzg1NTkwN2ZjZDUxODE4ZTc4N2QyNjZiMDdjYiIsInN1YiI6IjY2MjIxZDM0MzJjYzJiMDE3YzBlNDVhMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.c1CqCK45_jtuDIPQ-0u5g_cCl01PRdHzZj893ShZFYk"
    
    func fetchMovies(endpoint: String, page: Int = 1, language: String = "ko-KR") async throws -> Movie {
        guard var components = URLComponents(string: baseURL + endpoint) else {
            throw APIError.badURL
        }
        let queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "page", value: String(page))
        ]
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw APIError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let decodedResponse = try? JSONDecoder().decode(Movie.self, from: data) else {
            throw APIError.decodingError
        }
        return decodedResponse
    }
}

extension MovieManager {
    func fetchGenres(language: String = "ko") async throws -> Genre {
        guard var components = URLComponents(string: "https://api.themoviedb.org/3/genre/movie/list") else {
            throw APIError.badURL
        }
        let queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: language)
        ]
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw APIError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let decodedResponse = try? JSONDecoder().decode(Genre.self, from: data) else {
            throw APIError.decodingError
        }
        return decodedResponse
    }
}
