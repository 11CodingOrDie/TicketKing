//
//  GenreManager.swift
//  TicketKing
//
//  Created by David Jang on 4/22/24.
//

import Foundation

class GenreManager {
    static let shared = GenreManager()
    private var genres: [Int: String] = [:]
    private let movieService = MovieManager.shared
    
    func loadGenresAsync() async {
        await loadGenres()
    }
    
    private func loadGenres() async {
        do {
            let genreResponse = try await movieService.fetchGenres(language: "ko")
            self.genres = genreResponse.genres.reduce(into: [Int: String]()) { dict, genre in
                dict[genre.id] = genre.name
            }
        } catch {
            print("Error loading genres: \(error)")
        }
    }
    
    func genreNames(from ids: [Int]) -> String {
        let names = ids.compactMap { genres[$0] }.joined(separator: ", ")
        return names
    }
}
