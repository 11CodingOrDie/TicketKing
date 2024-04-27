//
//  DirectorManager.swift
//  TicketKing
//
//  Created by David Jang on 4/24/24.
//

import Foundation

class DirectorManager {
    static let shared = DirectorManager()
    private var directorsDetails: [Int: (name: String, profilePath: String?)] = [:]
    private let movieService = MovieManager.shared
    
    func loadDirectorsAsync(movieId: Int) async {
        do {
            let credits = try await movieService.fetchCredits(for: movieId)
            if let director = credits.crew.first(where: { $0.job.lowercased() == "director" }) {
                DispatchQueue.main.async { [weak self] in
                    self?.directorsDetails[movieId] = (name: director.name, profilePath: director.profilePath)
                }
            }
        } catch {
            print("Error loading directors: \(error)")
        }
    }
    
    func directorDetails(for movieId: Int) -> (name: String, profilePath: String?)? {
        return directorsDetails[movieId]
    }
}
