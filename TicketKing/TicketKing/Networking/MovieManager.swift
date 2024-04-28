//
//  MovieService.swift
//  TicketKing
//
//  Created by David Jang on 4/22/24.
//

import Foundation

enum APIError: Error {
    case badURL, requestError, decodingError, invalidImageData
}

class MovieManager {
    static let shared = MovieManager()
    private let baseURL = "https://api.themoviedb.org/3/"
    private let apiKey = "c38d7855907fcd51818e787d266b07cb"
    
    // 기본 영화 정보 가져오기 메서드
    func fetchMovies(endpoint: String, page: Int = 1, language: String = "ko-KR") async throws -> Movie {
        let requestURL = baseURL + endpoint
        guard var components = URLComponents(string: requestURL) else {
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
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.requestError
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(Movie.self, from: data)
            return decodedResponse
        } catch {
            throw APIError.decodingError
        }
    }
    
    // 이미지 로딩 메서드
    func fetchImage(from imagePath: String) async throws -> Data {
        let imageURL = "https://image.tmdb.org/t/p/w500" + imagePath
        guard let url = URL(string: imageURL) else {
            throw APIError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.invalidImageData
        }
        return data
    }
}


extension MovieManager {
    
    // 영화 상세정보
    func fetchMovieDetails(for movieId: Int, language: String = "ko-KR") async throws -> MovieDetails {
        let endpoint = "movie/\(movieId)"
        guard var components = URLComponents(string: "\(baseURL)\(endpoint)") else {
            throw APIError.badURL
        }

        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: language)
        ]

        guard let url = components.url else {
            throw APIError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.requestError
        }

        do {
            let decodedResponse = try JSONDecoder().decode(MovieDetails.self, from: data)
            return decodedResponse
        } catch {
            throw APIError.decodingError
        }
    }
    
    // 영화 출연진 및 제작진 정보 가져오기
    func fetchCredits(for movieId: Int, language: String = "ko-KR") async throws -> MovieCredits {
        let endpoint = "movie/\(movieId)/credits"
        guard let url = URL(string: "\(baseURL)\(endpoint)?api_key=\(apiKey)&language=\(language)") else {
            throw APIError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw APIError.requestError
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(MovieCredits.self, from: data)
            return decodedResponse
        } catch {
            throw APIError.decodingError
        }
    }
    
    // 특정 영화의 출연진 정보를 가져오는 메서드
    func fetchCast(for movieId: Int, language: String = "ko-KR") async throws -> [CastMember] {
        let credits = try await fetchCredits(for: movieId, language: language)
        return credits.cast
    }

    // 일별, 주차별 인기작 불러옴
    func fetchTrendingMovies(timeWindow: String, language: String = "ko-KR") async throws -> [MovieModel] {
        let endpoint = "trending/movie/\(timeWindow)"
        let movie = try await fetchMovies(endpoint: endpoint, language: language)
        return movie.results
    }
    
    // 개봉 예정 영화 데이터 가져오기
    func fetchUpcomingMovies(page: Int = 1, language: String = "ko-KR") async throws -> [MovieModel] {
        let endpoint = "movie/upcoming"
        let movie = try await fetchMovies(endpoint: endpoint, page: page, language: language)
        return movie.results
    }
    
    // 인기 영화 데이터 가져오기
    func fetchPopularMovies(page: Int = 1, language: String = "ko-KR") async throws -> [MovieModel] {
        let endpoint = "movie/popular"
        let movie = try await fetchMovies(endpoint: endpoint, page: page, language: language)
        return movie.results
    }
    
    // 현재 상영작
    func fetchNowPlayingMovies(page: Int = 1, language: String = "ko-KR") async throws -> [MovieModel] {
        let endpoint = "movie/now_playing"
        let movie = try await fetchMovies(endpoint: endpoint, page: page, language: language)
        return movie.results
    }
    
    // 현재 상영작 날짜 가져오기
    func fetchNowPlayingMovies2(page: Int = 1, language: String = "ko-KR") async throws -> Movie {
        let endpoint = "movie/now_playing"
        return try await fetchMovies(endpoint: endpoint, page: page, language: language)
    }
    
    // 영화 검색
    func searchMovies(query: String, page: Int = 1, language: String = "ko-KR") async throws -> [MovieModel] {
        let endpoint = "search/movie"
        guard var components = URLComponents(string: "\(baseURL)\(endpoint)") else {
            throw APIError.badURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "query", value: query),  // 검색어 추가
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "include_adult", value: "false")
        ]
        
        guard let url = components.url else {
            throw APIError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.requestError
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(Movie.self, from: data)
            return decodedResponse.results
        } catch {
            throw APIError.decodingError
        }
    }
    
    // 영화 장르
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
