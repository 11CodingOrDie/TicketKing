//
//  UserManager.swift
//  TicketKing
//
//  Created by David Jang on 4/23/24.
//

import Foundation


//class UserManager {
//    
//    static let shared = UserManager()
//    
//    private init() {}
//    
//    func saveUser(user: User) {
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(user) {
//            UserDefaults.standard.set(encoded, forKey: user.userID)
//        }
//    }
//    
//    func loadUser(username: String) -> User? {
//        if let savedUserData = UserDefaults.standard.object(forKey: username) as? Data {
//            let decoder = JSONDecoder()
//            if let loadedUser = try? decoder.decode(User.self, from: savedUserData) {
//                return loadedUser
//            }
//        }
//        return nil
//    }
//}


class UserManager {
    
    static let shared = UserManager()
    
    private init() {} // Singleton 패턴을 사용하는 경우 private 초기화를 사용합니다.
    
    // User 타입의 객체를 받아 UserDefaults에 JSON 형태로 저장하는 메서드
    func saveUser(user: User) {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(user)
            UserDefaults.standard.set(encoded, forKey: user.userID)
            print("User saved successfully")
            
            NotificationCenter.default.post(name: NSNotification.Name("UserLoggedIn"), object: nil)
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    
    // 저장된 User 데이터를 로드하는 메서드
    func loadUser(userID: String) -> User? {
        if let savedUserData = UserDefaults.standard.data(forKey: userID) {
            let decoder = JSONDecoder()
            do {
                let loadedUser = try decoder.decode(User.self, from: savedUserData)
                return loadedUser
            } catch {
                print("Failed to load user: \(error)")
            }
        }
        return nil
    }
}


