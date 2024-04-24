//
//  MainViewController.swift
//  TicketKing
//
//  Created by 이시안 on 4/23/24.
//

import Foundation
import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    var movies: [MovieModel] = []
    var releasedMovieView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24 // 행 사이 최소간격
        layout.scrollDirection = .horizontal // 스크롤 방향 지정
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // 섹션 여백 지정
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout) // 크기 0인 프레임 사용
        return cv
    }()
    var comingUpMovieView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    var movieSelect: ((MovieModel) -> Void)? //콜백함수..?
    
    
    
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
        configurereleasedMovieViewConstaint()
        
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
        return 10
    }
    
    //컬렉션뷰 cell은 어떤 모양으로
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {
            fatalError("error")
        }
        return cell
    }
    //셀 사이즈 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 221, height: 279)
    }
    
    
    
    
    //테이블뷰 설정
    func tableView() {
        comingUpMovieView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        comingUpMovieView.dataSource = self
        comingUpMovieView.delegate = self
        view.addSubview(comingUpMovieView)
    }
    //테이블뷰 몇줄
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    //테이블뷰 모양
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {
            fatalError("error")
        }
        return cell
    }
    
    
    
    
    //컬렉션뷰의 오토레이아웃
    func configurereleasedMovieViewConstaint() {
        releasedMovieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releasedMovieView.topAnchor.constraint(equalTo: view.topAnchor, constant: 186), // 원하는 Y 좌표로 설정
            releasedMovieView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            releasedMovieView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            releasedMovieView.heightAnchor.constraint(equalToConstant: 356) // 원하는 높이로 설정
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
