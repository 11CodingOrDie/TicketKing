//
//  CardViewController.swift
//  TicketKing
//
//  Created by David Jang on 4/24/24.
//

import UIKit
import SnapKit

class CardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var popularMovies: [MovieModel] = []
    var upcomingMovies: [MovieModel] = []
    var collectionView: UICollectionView!
    var secondCollectionView: UICollectionView! // 두 번째 컬렉션 뷰 추가

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupCollectionView()
        setupSecondCollectionView() // 두 번째 컬렉션 뷰 설정
        fetchPopularMovies()
        fetchUpcomingMovies()
    }
    
    private func fetchPopularMovies(language: String = "ko-KR", page: Int = 1) {
        Task {
            await GenreManager.shared.loadGenresAsync()
            do {
                let popularMovies = try await MovieManager.shared.fetchPopularMovies(page: page, language: language)
                self.popularMovies = popularMovies
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error fetching popular movies: \(error)")
            }
        }
    }

    // 상영 예정 영화 데이터 가져오기
    private func fetchUpcomingMovies(language: String = "ko-KR", page: Int = 1) {
        Task {
            await GenreManager.shared.loadGenresAsync()
            do {
                let upComingMovies = try await MovieManager.shared.fetchUpcomingMovies(page: page, language: language)
                self.upcomingMovies = upComingMovies
                DispatchQueue.main.async {
                    self.secondCollectionView.reloadData()
                }
            } catch {
                print("Error fetching upcoming movies: \(error)")
            }
        }
    }
    
    // 첫 번째 CollectionView 설정
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCardCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCardCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.frame.height / 2)
        }
    }
    
    // 두 번째 CollectionView 설정
    private func setupSecondCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 48
        secondCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        secondCollectionView.translatesAutoresizingMaskIntoConstraints = false
        secondCollectionView.register(MovieCardCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCardCollectionViewCell")
        secondCollectionView.dataSource = self
        secondCollectionView.delegate = self
        view.addSubview(secondCollectionView)
        
        secondCollectionView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.frame.height / 3)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.collectionView {
            return popularMovies.count
        } else {
            return upcomingMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCardCollectionViewCell", for: indexPath) as? MovieCardCollectionViewCell else {
            fatalError("Unable to dequeue MovieCardCollectionViewCell")
        }
        if collectionView === self.collectionView {
            cell.configure(with: popularMovies[indexPath.row], mode: .collectionCard)
        } else {
            cell.configure(with: upcomingMovies[indexPath.row], mode: .listCard)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === self.collectionView {
            return CGSize(width: 220, height: 280)  // 첫 번째 컬렉션뷰의 셀 크기
        } else {
            let padding: CGFloat = 10
            let collectionViewSize = collectionView.frame.size.width - padding * 4
            return CGSize(width: collectionViewSize / 3, height: collectionViewSize / 3)  // 두 번째 컬렉션뷰의 셀 크기
        }
    }
}

