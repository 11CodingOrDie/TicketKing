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

struct MovieDetails: Codable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: Collection?
    let budget: Int?
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbId: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct Collection: Codable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
}

struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

struct ProductionCountry: Codable {
    let iso31661: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}

struct SpokenLanguage: Codable {
    let englishName: String
    let iso6391: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso6391 = "iso_639_1"
        case name
    }
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


struct VideosResponse: Codable {
    let id: Int
    let results: [Video]
}

// 비디오 모델
struct Video: Codable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    let size: Int
    let iso6391: String
    let iso3166_1: String
    let official: Bool
    let publishedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case key
        case name
        case site
        case type
        case size
        case iso6391 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case official
        case publishedAt = "published_at"
    }
}


enum Language: String, Codable {
    case kr = "KR"
}

enum National: String, Codable {
    case ko = "ko"
}

enum Site: String, Codable {
    case youTube = "YouTube"
}

enum TypeEnum: String, Codable {
    case featurette = "Featurette"
    case teaser = "Teaser"
    case trailer = "Trailer"
}

// 비디오 응답 모델
struct VideoResponse: Codable {
    var id: Int
    var results: [Video]
}

// 제공사 정보
struct ProviderResponse: Codable {
    let results: [Provider]
}

struct Provider: Codable {
    let display_priorities: [String: Int]
    let display_priority: Int
    let logo_path: String
    let provider_name: String
    let provider_id: Int
}
