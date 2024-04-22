//
//  MovieModel.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/22/24.
//

import Foundation

// Movie Model
struct Movie: Codable {
    let dates: Dates
    let page: Int
    let movie: [MovieModel]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case dates, page, movie
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// Dates
struct Dates: Codable {
    let maximum, minimum: String
}

struct MovieModel: Codable {
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: OriginalLanguage
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case fr = "fr"
    case it = "it"
}


// Genre
struct Genre: Codable {
    let genres: [GenreModel]
}

struct GenreModel: Codable {
    let id: Int
    let name: String
}
