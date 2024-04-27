//
//  CastManager.swift
//  TicketKing
//
//  Created by David Jang on 4/26/24.
//

import Foundation

class CastManager {
    static let shared = CastManager()
    private var castCache: [Int: [CastMember]] = [:]
    private let movieService = MovieManager.shared

    // 영화 ID를 이용하여 출연진 정보를 비동기적으로 로드하고 캐싱
    func loadCast(for movieId: Int, completion: @escaping ([CastMember]?) -> Void) {
        Task {
            if let cachedCast = castCache[movieId] {
                completion(cachedCast)
            } else {
                do {
                    let cast = try await movieService.fetchCast(for: movieId)
                    DispatchQueue.main.async {
                        self.castCache[movieId] = cast
                        completion(cast)
                    }
                } catch {
                    print("Error loading cast: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }

    // 캐시에서 출연진 정보 조회
    func cast(for movieId: Int) -> [CastMember]? {
        return castCache[movieId]
    }
}

