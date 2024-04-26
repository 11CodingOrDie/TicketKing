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
//    var movieSelect: ((MovieModel) -> Void)? //콜백함수..?
    
    
    
    
    // 브랜드 로고 넣기
    let brandLogo: UIImageView = {
        let appTitle = UIImageView(image: UIImage(named: "title"))
        return appTitle
    }()

    //프로필 이미지칸 만들기
    let profileImage: (UIView, UIImageView) = {
        let myimage = UIView()
        let person = UIImageView(image: UIImage(named: "personIC"))
        myimage.backgroundColor = UIColor(named: "kGreen")
        myimage.layer.masksToBounds = true
        myimage.layer.cornerRadius = 10
        return (myimage, person) // 2개를 함께 추출하고 싶다면 타입 안에 2개를 넣기
    }()
    
    //글 불러오기
    let title1: UILabel = {
        let relesedTitle = UILabel()
        relesedTitle.text = "현재상영작"
        relesedTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return relesedTitle
    }()
    
    let title2: UILabel = {
        let relesedTitle = UILabel()
        relesedTitle.text = "상영예정작"
        relesedTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return relesedTitle
    }()
    
    //더보기버튼
    let seeAllMovies: UIButton = {
        let moreFilms = UIButton()
        moreFilms.setTitle("더보기>>", for: .normal)
        moreFilms.setTitleColor(UIColor(named: "kRed"), for: .normal)
        moreFilms.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return moreFilms
    }()
    
    //상영예정 더보기버튼
    let seeUpComingMovies: UIButton = {
        let moreFilms = UIButton()
        moreFilms.setTitle("더보기>>", for: .normal)
        moreFilms.setTitleColor(UIColor(named: "kRed"), for: .normal)
        moreFilms.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return moreFilms
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
        
        view.addSubview(brandLogo)
        view.addSubview(profileImage.0)
        let (myimage, person) = profileImage // 튜플을 풀어서 개별 뷰를 변수에 할당합니다.
        view.addSubview(myimage) // myimage를 추가합니다.
        myimage.addSubview(person) // person을 추가합니다.
        view.addSubview(title1)
        view.addSubview(title2)
        view.addSubview(seeAllMovies)
        view.addSubview(seeUpComingMovies)
        autoLayout()
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
    } //지정한 컬렉션뷰로 데이터 이동
    
    
    
    
    //컬렉션뷰 설정
    func collectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        releasedMovieView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        releasedMovieView.showsHorizontalScrollIndicator = false
        releasedMovieView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        releasedMovieView.dataSource = self
        releasedMovieView.delegate = self
        view.addSubview(releasedMovieView)
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
        comingUpMovieView.estimatedRowHeight = 88 //셀의 높이
        comingUpMovieView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        comingUpMovieView.dataSource = self
        comingUpMovieView.delegate = self
        view.addSubview(comingUpMovieView)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // 원하는 높이를 리턴합니다.
    }
    
    
    
    
    //컬렉션뷰의 오토레이아웃
    func configurereleasedMovieViewConstaint() {
        releasedMovieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releasedMovieView.topAnchor.constraint(equalTo: view.topAnchor, constant: 140), // 원하는 Y 좌표로 설정
            releasedMovieView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            releasedMovieView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            releasedMovieView.heightAnchor.constraint(equalToConstant: 400) // 원하는 높이로 설정
        ])
    }
    
    //테이블뷰 오토레이아웃
    func configureComingUpMovieViewConstaint() {
        comingUpMovieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            comingUpMovieView.topAnchor.constraint(equalTo: view.topAnchor, constant: 615), // 원하는 Y 좌표로 설정
            comingUpMovieView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            comingUpMovieView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            comingUpMovieView.heightAnchor.constraint(equalToConstant: 145) // 화면에 보여질 높이 설정
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
        
        title1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title1.topAnchor.constraint(equalTo: view.topAnchor, constant: 144),
            title1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            title1.widthAnchor.constraint(equalToConstant: 74),
            title1.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        title2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title2.topAnchor.constraint(equalTo: view.topAnchor, constant: 578),
            title2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            title2.widthAnchor.constraint(equalToConstant: 74),
            title2.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        seeAllMovies.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeAllMovies.topAnchor.constraint(equalTo: view.topAnchor, constant: 144),
            seeAllMovies.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 304),
            seeAllMovies.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        seeUpComingMovies.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeUpComingMovies.topAnchor.constraint(equalTo: view.topAnchor, constant: 578),
            seeUpComingMovies.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 304),
            seeUpComingMovies.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        // 튜플에서 두 개의 뷰를 추출합니다.
        let (myimage, person) = profileImage
        // myimage의 오토레이아웃을 설정합니다.
        myimage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myimage.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            myimage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 321),
            myimage.widthAnchor.constraint(equalToConstant: 44),
            myimage.heightAnchor.constraint(equalToConstant: 44)
        ])
        // person의 오토레이아웃을 설정합니다.
        person.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            person.topAnchor.constraint(equalTo: myimage.topAnchor, constant: 5), // myimage의 상단에 맞춤
            person.leadingAnchor.constraint(equalTo: myimage.leadingAnchor, constant: 5), // myimage의 왼쪽에 맞추고 간격 추가
            person.trailingAnchor.constraint(equalTo: myimage.trailingAnchor, constant: -5), // myimage의 오른쪽에 맞추고 간격 추가
            person.bottomAnchor.constraint(equalTo: myimage.bottomAnchor, constant: -5) // myimage의 하단에 맞춤
        ])
    }
    
    
}
