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
    var birthdate: Date?
    var gender: String?
    
    init(userID: String, password: String, email: String, name: String, birthdate: Date? = nil, gender: String? = nil) {
        self.userID = userID
        self.password = password
        self.email = email
        self.name = name
        self.birthdate = birthdate
        self.gender = gender
    }
}
