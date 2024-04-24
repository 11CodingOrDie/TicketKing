//
//  MovieViewController.swift
//  TicketKing
//
//  Created by David Jang on 4/24/24.
//

import Foundation
import UIKit
import SnapKit

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var movies: [MovieModel] = []
    var tableView: UITableView!
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupTableView()
        setupCollectionView()
        fetchData()
    }
    
    // TableView 설정
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieInfoTableViewCell.self, forCellReuseIdentifier: "MovieInfoTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.frame.height / 2)  // 화면의 절반 크기
        }
    }
    
    // CollectionView 설정
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieInfoCollectionViewCell.self, forCellWithReuseIdentifier: "MovieInfoCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.frame.height / 2)  // 화면절반
        }
    }
    
    // 영화 데이터 가져오기
    private func fetchData() {
        Task {
            await GenreManager.shared.loadGenresAsync()
            do {
                let movieResponse = try await MovieManager.shared.fetchMovies(endpoint: "now_playing")
                self.movies = movieResponse.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error fetching movies: \(error)")
            }
        }
    }
    
    // TableView DataSource 및 Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoTableViewCell", for: indexPath) as? MovieInfoTableViewCell else {
            fatalError("Unable to dequeue MovieInfoTableViewCell")
        }
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100  // 테이블 뷰 셀의 높이 설정
    }

    // CollectionView DataSource 및 Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieInfoCollectionViewCell", for: indexPath) as? MovieInfoCollectionViewCell else {
            fatalError("Unable to dequeue MovieInfoCollectionViewCell")
        }
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 57)  // 컬렉션 뷰 셀 크기
    }
}
