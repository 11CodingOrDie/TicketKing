//
//  MovieModel.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/22/24.
//

import Foundation

// 영화 목록 모델
struct Movie: Codable {
    let dates: Dates?
    let page: Int
    let results: [MovieModel]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// 개별 영화 모델
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
    case unknown
    
    init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        self = OriginalLanguage(rawValue: label) ?? .unknown
    }
}

// 영화 상세정보 모델
struct MovieDetails: Codable {
    let adult: Bool
    let backdropPath: String?
    let genres: [Genre]
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let runtime: Int?
    let voteAverage: Double
    let voteCount: Int
}

// 영화 크레딧 모델
struct MovieCredits: Codable {
    let id: Int
    let cast: [CastMember]
    let crew: [CrewMember]

    enum CodingKeys: String, CodingKey {
        case id, cast, crew
    }
}

// 출연진 모델
struct CastMember: Codable {
    let castId: Int
    let character: String
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case castId = "cast_id"
        case character, name
        case profilePath = "profile_path"
    }
}

// 스태프 모델
struct CrewMember: Codable {
    let id: Int
    let job: String
    let department: String
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, job, department, name
        case profilePath = "profile_path"
    }
}

// 장르 모델
struct Genre: Codable {
    let genres: [GenreModel]
}

struct GenreModel: Codable {
    let id: Int
    let name: String
}

// 날짜 모델
struct Dates: Codable {
    let maximum, minimum: String
}
