//
//  MovieDetailView.swift
//  TicketKing
//
//  Created by David Jang on 4/26/24.
//

import UIKit
import SnapKit
import SDWebImage

class MovieDetailView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    private lazy var contentView: UIView = {
            let view = UIView()
            return view
        }()
    
    private let posterImageView = UIImageView()
    private let directorImageView = UIImageView()
    private var directorCardView: PersonInfoCell?
    
    private let movieTitleLabel = UILabel()
    private let directorNameLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let movieDescriptionLabel = UILabel()
    
    private var actorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let bookButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor(red: 0.102, green: 0.604, blue: 0.545, alpha: 1).cgColor
        button.setTitle("예매하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5.5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        return button
    }()
    
    private lazy var videoTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: "VideoTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private var castMembers: [CastMember] = []
    private var videos: [Video] = []
    private var isHeartFilled = false
    private var starRatingView: StarRatingView?

    
    var movie: MovieModel? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = [.top, .left, .right]
        configureNavigationBar()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(bookButton)
        contentView.addSubview(videoTableView)
        setupViews()
        setupScrollView()
        setupBookButton()
        setupActorCollectionView()
        setupConstraints()
//        setupVideoTableView()
//        setupStarRatingView()     // 평점 별 추가 예정
        
//        videoTableView.estimatedRowHeight = 32
//        videoTableView.estimatedSectionFooterHeight = 32
//        videoTableView.estimatedSectionHeaderHeight = 1
        
        
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func registerCells() {
        actorCollectionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: "ActorCollectionViewCell")
    }
    
    private func setupScrollView() {
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(bookButton.snp.top)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
            // 높이 제약을 제거하거나 수정합니다.
        }
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupBookButton() {
        bookButton.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(60)
        }
        bookButton.addTarget(self, action: #selector(bookButtonTapped), for: .touchUpInside)
    }
    
    @objc private func bookButtonTapped() {
        let bookingVC = BookingMovieViewController()
        let navController = UINavigationController(rootViewController: bookingVC)
        navController.modalPresentationStyle = .fullScreen
        bookingVC.movie = self.movie  // 영화 정보 전달
        present(navController, animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(directorNameLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(movieDescriptionLabel)
        contentView.addSubview(actorCollectionView)
        
        
        if let movieId = movie?.id {
            let directorView = PersonInfoCell(frame: .zero, movieId: movieId, viewMode: .director)
            directorCardView = directorView
            contentView.addSubview(directorView)
        }
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        movieTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        directorNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        releaseDateLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        movieDescriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        movieDescriptionLabel.numberOfLines = 0
        
        
        
    }
    
    private func loadData(movieId: Int) {
        Task {
            do {
                let credits = try await MovieManager.shared.fetchCredits(for: movieId)
                DispatchQueue.main.async {
                    self.castMembers = credits.cast
                    self.actorCollectionView.reloadData()
                }
            } catch {
                print("Error loading cast data: \(error)")
            }
        }
    }
    
    
    private func setupStarRatingView() {
        guard let voteAverage = movie?.voteAverage else { return }
        let starView = StarRatingView(frame: CGRect(x: 0, y: 0, width: 100, height: 20), rating: voteAverage)
        contentView.addSubview(starView)
        starView.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(releaseDateLabel.snp.trailing)
            make.trailing.equalTo(view.snp.trailing).offset(16)
        }
        self.starRatingView = starView
    }
    
    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        directorCardView?.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(-60) // 포스터 이미지와 겹치도록
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(160)
            make.height.equalTo(200)
        }
        
        directorNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(directorCardView?.snp.centerY ?? 0)
            make.leading.equalTo(directorCardView?.snp.trailing ?? 0).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(directorCardView?.snp.bottom ?? 0).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(movieTitleLabel.snp.leading)
        }
        
        movieDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(16)
            make.leading.equalTo(movieTitleLabel.snp.leading)
            make.trailing.equalTo(movieTitleLabel.snp.trailing)
        }
        
        actorCollectionView.snp.makeConstraints { make in
            make.top.equalTo(movieDescriptionLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        videoTableView.snp.makeConstraints { make in
            make.top.equalTo(actorCollectionView.snp.bottom).offset(32)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)  // contentView의 하단과 비디오 테이블 뷰의 바닥을 연결
            make.height.equalTo(500) // 높이는 필요에 따라 조정하세요.
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBarItems()
        checkFavoriteStatusAndUpdateHeart()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

    }


    private func configureNavigationBarItems() {

        let backItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backItem
        let heartItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(toggleHeart))
        heartItem.tintColor = .red
        navigationItem.rightBarButtonItem = heartItem
    }
    
    private func checkFavoriteStatusAndUpdateHeart() {
        guard let movieId = movie?.id, let userID = UserDefaults.standard.string(forKey: "currentUserID"),
              let user = UserManager.shared.loadUser(userID: userID) else {
            print("Failed to load user profile or movie data is missing")
            return
        }

        isHeartFilled = user.favoriteMovies.contains(String(movieId))
        updateHeartIcon()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    private func loadData() {
        guard let movie = movie else { return }
        posterImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)"), placeholderImage: UIImage(named: "placeholder"))
        movieTitleLabel.text = movie.title
        releaseDateLabel.text = "개봉일자: \(movie.releaseDate)"
        movieDescriptionLabel.text = movie.overview
        loadDirectorInfo(movieId: movie.id)
        loadVideos(movieId: movie.id) // 수정된 부분: 비디오 데이터 로드
    }
    
    private func loadDirectorInfo(movieId: Int) {
        Task {
            let credits = try await MovieManager.shared.fetchCredits(for: movieId)
            if let director = credits.crew.first(where: { $0.job.lowercased() == "director" }) {
                DispatchQueue.main.async {
                    if let voteAverage = self.movie?.voteAverage {
                        self.directorNameLabel.text = String(format: "평점: %.1f", voteAverage)
                    }
                    if let profilePath = director.profilePath {
                        let directorImageURL = "https://image.tmdb.org/t/p/w500\(profilePath)"
                        self.directorImageView.sd_setImage(with: URL(string: directorImageURL), placeholderImage: UIImage(named: "placeholder"))
                    }
                }
            }
        }
    }
    
    private func setupActorCollectionView() {
        actorCollectionView.dataSource = self
        actorCollectionView.delegate = self
        actorCollectionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: "ActorCollectionViewCell")
        actorCollectionView.showsHorizontalScrollIndicator = true
        actorCollectionView.backgroundColor = .white
        contentView.addSubview(actorCollectionView)
        
        // 데이터 로드
        if let movieId = movie?.id {
            loadData(movieId: movieId)
        }
        registerCells()
    }
    
    private func loadCastData(movieId: Int) {
        Task {
            let credits = try await MovieManager.shared.fetchCredits(for: movieId)
            DispatchQueue.main.async {
                self.castMembers = credits.cast
                self.actorCollectionView.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castMembers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorCollectionViewCell", for: indexPath) as? ActorCollectionViewCell else {
            fatalError("Unable to dequeue ActorCell")
        }
        let castMember = castMembers[indexPath.row]
        cell.configure(with: castMember)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 200)
    }

    
//    private func setupVideoTableView() {
//        contentView.addSubview(videoTableView)
//        videoTableView.snp.makeConstraints { make in
//            make.top.equalTo(actorCollectionView.snp.bottom).offset(32)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(500)  // 높이는 필요에 따라 조정하세요.
//            make.bottom.equalTo(contentView.snp.bottom)  // contentView의 바닥과 비디오 테이블 뷰의 바닥을 연결
//        }
//    }
    
    private func loadVideos(movieId: Int) {
        print("Loading videos for movie ID: \(movieId)") // 로딩 시작 로그
        Task {
            do {
                let fetchedVideos = try await MovieManager.shared.fetchVideos(for: movieId)
                DispatchQueue.main.async {
                    self.videos = fetchedVideos
                    self.videoTableView.reloadData()
                    print("Videos loaded: \(self.videos.count)") // 로드된 비디오 수 로그
                    if self.videos.isEmpty {
                        print("No videos found for movie ID \(movieId)")
                    } else {
                        for video in self.videos {
                            print("Video loaded: \(video.name)") // 로드된 각 비디오의 이름 로그
                        }
                    }
                }
            } catch {
                print("Error loading videos: \(error)") // 에러 발생 시 로그
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as? VideoTableViewCell else {
            fatalError("Unable to dequeue VideoTableViewCell")
        }
        let video = videos[indexPath.row]
        cell.configure(with: video)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 20 : 10  // 첫 섹션에는 20, 그 외 섹션에는 10
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

extension MovieDetailView {
    @objc private func toggleHeart() {
        guard let movie = movie, let userID = UserDefaults.standard.string(forKey: "currentUserID"),
              var user = UserManager.shared.loadUser(userID: userID) else {
            print("Failed to load user profile or movie data is missing")
            return
        }

        isHeartFilled.toggle()

        if isHeartFilled {
            user.favoriteMovies.append(String(movie.id))
            print("Added to favorites: Movie ID \(movie.id)")
        } else {
            user.favoriteMovies.removeAll { $0 == String(movie.id) }
            print("Removed from favorites: Movie ID \(movie.id)")
        }

        UserManager.shared.saveUser(user: user)
        print("Current favorite movies: \(user.favoriteMovies)")

        updateHeartIcon()
    }

    private func updateHeartIcon() {
        let heartIconName = isHeartFilled ? "heart.fill" : "heart"
        let heartIcon = UIImage(systemName: heartIconName)?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem?.image = heartIcon
    }
}

