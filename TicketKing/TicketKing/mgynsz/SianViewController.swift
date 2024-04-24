//
//  SianViewController.swift
//  TicketKing
//
//  Created by David Jang on 4/24/24.
//

import UIKit

class SianViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var movies: [MovieModel] = []
    var releasedMovieView: UICollectionView!
    var comingUpMovieView: UITableView!
    var movieSelect: ((MovieModel) -> Void)? // 콜백함수

    // 브랜드 로고
    private let brandLogo: UIImageView = {
        let appTitle = UIImageView(image: UIImage(named: "title"))
        appTitle.frame.size = CGSize(width: 138, height: 29.58)
        return appTitle
    }()

    // 프로필 이미지
    private let profileImage: (UIView, UIImageView) = {
        let myImage = UIView()
        let person = UIImageView(image: UIImage(named: "personIC"))
        myImage.frame.size = CGSize(width: 44, height: 44)
        person.frame.size = CGSize(width: 30, height: 30)
        myImage.backgroundColor = UIColor(named: "kGreen")
        myImage.layer.masksToBounds = true
        myImage.layer.cornerRadius = 10
        myImage.addSubview(person)
        person.center = CGPoint(x: myImage.bounds.midX, y: myImage.bounds.midY)
        return (myImage, person)
    }()

    // 글 불러오기
    private let title1: UILabel = {
        let releasedTitle = UILabel()
        releasedTitle.text = "현재상영작"
        releasedTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        releasedTitle.frame.size = CGSize(width: 74, height: 22)
        return releasedTitle
    }()

    private let title2: UILabel = {
        let releasedTitle = UILabel()
        releasedTitle.text = "상영예정작"
        releasedTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        releasedTitle.frame.size = CGSize(width: 74, height: 22)
        return releasedTitle
    }()

    // 더보기 버튼
    private let seeAllMovies: UIButton = {
        let moreFilms = UIButton()
        moreFilms.setTitle("더보기>>", for: .normal)
        moreFilms.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        moreFilms.backgroundColor = .systemBackground
        return moreFilms
    }()

    // 상영예정 더보기버튼
    private let seeUpComingMovies: UIButton = {
        let moreFilms = UIButton()
        moreFilms.setTitle("더보기>>", for: .normal)
        moreFilms.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        moreFilms.backgroundColor = .systemBackground
        return moreFilms
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupTableView()
    }

    // 컬렉션뷰 설정
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        releasedMovieView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        releasedMovieView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        releasedMovieView.showsHorizontalScrollIndicator = false
        releasedMovieView.dataSource = self
        releasedMovieView.delegate = self
        view.addSubview(releasedMovieView)
        configurereleasedMovieViewConstraint()
    }

    // 테이블뷰 설정
    func setupTableView() {
        comingUpMovieView = UITableView(frame: .zero, style: .plain)
        comingUpMovieView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        comingUpMovieView.dataSource = self
        comingUpMovieView.delegate = self
        view.addSubview(comingUpMovieView)
        configureComingUpMovieViewConstraint()
    }

    // 컬렉션뷰 레이아웃 설정
    func configurereleasedMovieViewConstraint() {
        releasedMovieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releasedMovieView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            releasedMovieView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            releasedMovieView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            releasedMovieView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    // 테이블뷰 레이아웃 설정
    func configureComingUpMovieViewConstraint() {
        comingUpMovieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            comingUpMovieView.topAnchor.constraint(equalTo: releasedMovieView.bottomAnchor, constant: 20),
            comingUpMovieView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comingUpMovieView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comingUpMovieView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    // 컬렉션뷰 데이터 소스 및 델리게이트 메서드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {
            fatalError("Unable to dequeue MainCollectionViewCell")
        }
        cell.configure(with: movies[indexPath.row])
        return cell
    }

    // 테이블뷰 데이터 소스 및 델리게이트 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = movies[indexPath.row].title
        return cell
    }
}
