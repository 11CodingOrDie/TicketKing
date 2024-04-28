//
//  FavoritesViewController.swift
//  TicketKing
//
//  Created by David Jang on 4/29/24.
//

import Foundation
import UIKit
import SnapKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    var favoriteMovies: [MovieModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadFavoriteMovies()
        setupLayout()
    }

    private func setupLayout() {
        view.backgroundColor = .white
        title = "Favorite Movies"
    }

    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieInfoTableViewCell.self, forCellReuseIdentifier: "MovieInfoTableViewCell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
//    private func loadFavoriteMovies() {
//        // 데이터 로딩 후
//        print("Loaded favorite movies: \(favoriteMovies.count)")
//        tableView.reloadData()
//    }

    private func loadFavoriteMovies() {
        
        print("Loaded favorite movies: \(favoriteMovies.count)")
        tableView.reloadData()
        guard let user = UserManager.shared.loadUser(userID: UserDefaults.standard.string(forKey: "currentUserID") ?? "") else {
            print("Failed to load user or no user ID found")
            return
        }

        favoriteMovies = user.favoriteMovies.map {
            MovieModel(
                genreIDS: [0], // Dummy genre ID
                id: 0, // Dummy movie ID
                originalLanguage: .en,
                originalTitle: $0, // Assuming the original title is the same as the title
                overview: "No overview available.",
                popularity: 0.0,
                posterPath: "", // No poster path available
                releaseDate: "2021-01-01", // Dummy release date
                title: $0,
                voteAverage: 0.0
            )
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoTableViewCell", for: indexPath) as? MovieInfoTableViewCell else {
            return UITableViewCell()
        }
        let movie = favoriteMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
