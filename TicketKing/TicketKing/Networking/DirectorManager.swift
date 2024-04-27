//
//  DirectorManager.swift
//  TicketKing
//
//  Created by David Jang on 4/24/24.
//

import Foundation

class DirectorManager {
    static let shared = DirectorManager()
    private var directors: [Int: String] = [:]
    private let movieService = MovieManager.shared
    
    func loadDirectorsAsync(movieId: Int) async {
            do {
                let credits = try await movieService.fetchCredits(for: movieId)
                if let director = credits.crew.first(where: { $0.job.lowercased() == "director" }) {
                    DispatchQueue.main.async { [weak self] in
                        self?.directors[movieId] = director.name
                    }
                }
            } catch {
                print("Error loading directors: \(error)")
            }
        }
    
    func directorName(for movieId: Int) -> String? {
        return directors[movieId]
    }
}
