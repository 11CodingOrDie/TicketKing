//
//  MainViewController.swift
//  TicketKing
//
//  Created by 이시안 on 4/23/24.
//

import Foundation
import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource{
    
    var popularMovies: [MovieModel] = [] //가져올 정보가 담긴 파일의 이름과 형식 설정
    var upcomingMovies: [MovieModel] = []
    
    var releasedMovieView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24 // 행 사이 최소간격
        layout.scrollDirection = .horizontal // 스크롤 방향을 수평으로 변경
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout) // 크기 0인 프레임 사용
        return cv
    }()
    var comingUpMovieView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // 브랜드 로고 넣기
    let brandLogo: UIImageView = {
        let appTitle = UIImageView(image: UIImage(named: "title"))
        return appTitle
    }()
    
    //프로필 이미지칸 만들기
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person")) // 기본 이미지 설정
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        tableView()
        collectionView()
        fetchPopularMovies()
        fetchUpcomingMovies()
        addMoviesToCollectionView()
        configurereleasedMovieViewConstaint()
        configureComingUpMovieViewConstaint()
        fixeCollectionViewdHeader()
        loadUserProfile()
        
        if let userID = UserDefaults.standard.string(forKey: "currentUserID") {
            loadImage(userID: userID)
        } else {
            print("No user ID found in UserDefaults")
        }
        comingUpMovieView.delegate = self
        // 네비게이션 바 투명 처리
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileImage), name: .profileImageUpdated, object: nil)
        
        view.addSubview(brandLogo)
        view.addSubview(profileImageView)
        autoLayout()
        
        view.addSubview(profileImageView)
    }
    
    @objc func updateProfileImage() {
        if let userID = UserDefaults.standard.string(forKey: "currentUserID") {
            loadImage(userID: userID)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadImage(userID: String) {
        let filenameKey = "profileImageFilename_\(userID)"
        if let filename = UserDefaults.standard.string(forKey: filenameKey) {
            let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
            if let imageData = FileManager.default.contents(atPath: fileURL.path) {
                let image = UIImage(data: imageData)
                profileImageView.image = image
                print("Loaded image from: \(fileURL)")
            } else {
                // 이미지 파일이 없거나 읽을 수 없을 때 기본 이미지 설정
                profileImageView.image = UIImage(systemName: "person")
                print("Failed to load image from \(fileURL)")
            }
        } else {
            // UserDefaults에 파일 이름이 저장되어 있지 않을 때
            profileImageView.image = UIImage(systemName: "person")
            print("No image found for user \(userID)")
        }
    }
    
    // Documents 디렉토리의 URL을 반환하는 함수
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc private func loadUserProfile() {
        guard UserDefaults.standard.string(forKey: "currentUserID") != nil else {
            print("No user ID found in UserDefaults")
            return
        }
    }
    
    //인기 영화 데이터 가져오기
    private func fetchPopularMovies(language: String = "ko-KR", page: Int = 1) {
        Task {
            await GenreManager.shared.loadGenresAsync()
            do {
                let popularMovies = try await MovieManager.shared.fetchPopularMovies(page: page, language: language)
                self.popularMovies = popularMovies
                DispatchQueue.main.async {
                    self.releasedMovieView.reloadData()
                }
            } catch {
                print("Error fetching popular movies: \(error)")
            }
        }
    }
    
    //개봉 얘정작 데이터 가져오기
    private func fetchUpcomingMovies(language: String = "ko-KR", page: Int = 1) {
        Task {
            await GenreManager.shared.loadGenresAsync()
            do {
                let upcomingMovies = try await MovieManager.shared.fetchUpcomingMovies(page: page, language: language)
                self.upcomingMovies = upcomingMovies
                DispatchQueue.main.async {
                    self.comingUpMovieView.reloadData()
                }
            } catch {
                print("Error fetching popular movies: \(error)")
            }
        }
    }
    
    private func addMoviesToCollectionView() {
        releasedMovieView.reloadData()
    }
    
    //컬렉션뷰 설정
    func collectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10  // 아이템 간 수직 간격
        layout.minimumLineSpacing = 10       // 아이템 간 수평 간격 (셀과 셀 사이)
        releasedMovieView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        releasedMovieView.showsHorizontalScrollIndicator = false
        releasedMovieView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        releasedMovieView.dataSource = self
        releasedMovieView.delegate = self
        view.addSubview(releasedMovieView)
    }
    
    func fixeCollectionViewdHeader() {
        let fixedHeaderLabel = UILabel(frame: CGRect(x: 32, y: view.safeAreaInsets.top + 120, width: view.bounds.width - 32, height: 50))
        fixedHeaderLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        fixedHeaderLabel.text = "현재 상영작"
        view.addSubview(fixedHeaderLabel)
    }
    
    //컬렉션뷰 한 줄에 몇개
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {
            fatalError("Unable to dequeue MovieCardCollectionViewCell")
        }
        
        if collectionView === self.releasedMovieView {
            cell.configure(with: popularMovies[indexPath.row], mode: .collectionCard)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let selectedMovie = popularMovies[indexPath.row]
           let detailViewController = MovieDetailView()
           detailViewController.movie = selectedMovie  // 영화 정보 전달

           let navigationController = UINavigationController(rootViewController: detailViewController)

           // 모달 뷰 전체 화면으로 설정
           navigationController.modalPresentationStyle = .fullScreen

           // 현재 뷰 컨트롤러에서 모달 방식으로 네비게이션 컨트롤러 표시
           present(navigationController, animated: true)
       }
    
    
    
    //셀 사이즈 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === self.releasedMovieView {
            return CGSize(width: 220, height: 280)  // 첫 번째 컬렉션뷰의 셀 크기
        } else {
            let padding: CGFloat = 10
            let collectionViewSize = collectionView.frame.size.width - padding * 4
            return CGSize(width: collectionViewSize / 3, height: collectionViewSize / 3)  // 두 번째 컬렉션뷰의 셀 크기
        }
    }
    
    // 테이블뷰 설정
    func tableView() {
        comingUpMovieView.rowHeight = UITableView.automaticDimension
        comingUpMovieView.estimatedRowHeight = 88
        comingUpMovieView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        comingUpMovieView.dataSource = self
        comingUpMovieView.delegate = self
        view.addSubview(comingUpMovieView)
        
        // 헤더 뷰 설정
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        let headerLabel = UILabel(frame: headerView.bounds.insetBy(dx: 16, dy: 0))
        headerLabel.text = "상영 예정작"
        headerLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        headerView.addSubview(headerLabel)
        
        comingUpMovieView.tableHeaderView = headerView
    }
    
    //테이블뷰 몇줄
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMovies.count
    }
    //테이블뷰 모양
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {
            fatalError("Unable to dequeue MovieInfoTableViewCell")
        }
        cell.configure(with: upcomingMovies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = .lightGray
        header.textLabel?.textColor = .black
        header.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = upcomingMovies[indexPath.row]
        let detailViewController = MovieDetailView()
        detailViewController.movie = selectedMovie  // 영화 정보 전달

        let navigationController = UINavigationController(rootViewController: detailViewController)

        // 모달 뷰 전체 화면으로 설정
        navigationController.modalPresentationStyle = .fullScreen

        // 현재 뷰 컨트롤러에서 모달 방식으로 네비게이션 컨트롤러 표시
        present(navigationController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // 원하는 높이를 리턴합니다.
    }
    
    //컬렉션뷰의 오토레이아웃
    func configurereleasedMovieViewConstaint() {
        releasedMovieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releasedMovieView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130), // 원하는 Y 좌표로 설정
            releasedMovieView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            releasedMovieView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            releasedMovieView.heightAnchor.constraint(equalToConstant: 350) // 원하는 높이로 설정
        ])
    }
    
    //테이블뷰 오토레이아웃
    func configureComingUpMovieViewConstaint() {
        comingUpMovieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            comingUpMovieView.topAnchor.constraint(equalTo: releasedMovieView.bottomAnchor, constant: 16), // 컬렉션 뷰 아래로 위치 조정
            comingUpMovieView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            comingUpMovieView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            comingUpMovieView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16) // 하단 안전 영역까지 확장
        ])
    }
    
    func autoLayout() {
        
        brandLogo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //x좌표와 y좌표 잡기
            brandLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            brandLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            //사이즈 지정
            brandLogo.widthAnchor.constraint(equalToConstant: 138),
            brandLogo.heightAnchor.constraint(equalToConstant: 29.58)
        ])
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 321),
            profileImageView.widthAnchor.constraint(equalToConstant: 44),
            profileImageView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}

extension Notification.Name {
    static let profileImageUpdated = Notification.Name("profileImageUpdated")
}
