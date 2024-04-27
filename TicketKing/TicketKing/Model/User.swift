//
//  User.swift
//  TicketKing
//
//  Created by David Jang on 4/23/24.
//

import Foundation

struct User: Codable {
    var userID: String
    var password: String
    var email: String
    var name: String
    var favoriteMovies: [String]
    var bookedMovies: [String]
    var profileImageData: Data?

    init(userID: String, password: String, email: String, name: String, favoriteMovies: [String] = [], bookedMovies: [String] = [], profileImageData: Data? = nil) {
        self.userID = userID
        self.password = password
        self.email = email
        self.name = name
        self.favoriteMovies = favoriteMovies
        self.bookedMovies = bookedMovies
        self.profileImageData = profileImageData
    }
}
