//
//  UserManager.swift
//  TicketKing
//
//  Created by David Jang on 4/23/24.
//

import Foundation


class UserManager {
    static let shared = UserManager()
    
    func saveUser(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: user.userID)
        }
    }
    
    func getUser(username: String) -> User? {
        if let savedUserData = UserDefaults.standard.object(forKey: username) as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(User.self, from: savedUserData) {
                return loadedUser
            }
        }
        return nil
    }
}

