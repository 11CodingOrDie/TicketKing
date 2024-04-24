//
//  MainViewController.swift
//  TicketKing
//
//  Created by 이시안 on 4/23/24.
//

import Foundation
import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var movies: [MovieModel] = []
    var releasedMovieView: UICollectionView = UICollectionView()
    var comingUpMovieView: UITableView = UITableView()
    var movieSelect: ((MovieModel) -> Void)? //콜백함수..?
    
    // 브랜드 로고 넣기
    let brandLogo: UIImageView = {
        let appTitle = UIImageView(image: UIImage(named: "title"))
        // 이미지 뷰의 크기 설정
        appTitle.frame.size = CGSize(width: 138, height: 29.58)
        return appTitle
    }()
    
    //프로필 이미지칸 만들기
    let profileImage: (UIView, UIImageView) = {
        let myimage = UIView()
        let person = UIImageView(image: UIImage(named: "personIC"))
        myimage.frame.size = CGSize(width: 44, height: 44)
        person.frame.size = CGSize(width: 30, height: 30)
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
        relesedTitle.frame.size = CGSize(width: 74, height: 22)
        return relesedTitle
    }()
    
    let title2: UILabel = {
        let relesedTitle = UILabel()
        relesedTitle.text = "상영예정작"
        relesedTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        relesedTitle.frame.size = CGSize(width: 74, height: 22)
        return relesedTitle
    }()
    
    //더보기버튼
    let seeAllMovies: UIButton = {
        let moreFilms = UIButton()
        moreFilms.titleLabel?.text = "더보기>>"
        moreFilms.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        moreFilms.backgroundColor = .systemBackground
        return moreFilms
    }()
    
    //상영예정 더보기버튼
    let seeUpComingMovies: UIButton = {
        let moreFilms = UIButton()
        moreFilms.titleLabel?.text = "더보기>>"
        moreFilms.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        moreFilms.backgroundColor = .systemBackground
        return moreFilms
    }()
    
    
    
    
        
    override func viewDidLoad() {
            super.viewDidLoad()
            collectionView()
            
            view.addSubview(releasedMovieView)
            releasedMovieView.dataSource = self
            releasedMovieView.delegate = self
            releasedMovieView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
            
            configurereleasedMovieViewConstaint()
        }
        
        
    
        
        //컬렉션뷰 설정
        func collectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.showsHorizontalScrollIndicator = false
            // 추가적인 설정 가능
        }
        
        //컬렉션뷰 한 줄에 몇개
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return movies.count
        }
        
        //컬렉션뷰 cell은 어떤 모양으로
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {
                fatalError("error")
            }
            cell.configure(with: movies[indexPath.item])
            return cell
        }
        
        func configurereleasedMovieViewConstaint() {
            releasedMovieView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                releasedMovieView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                releasedMovieView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                releasedMovieView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                releasedMovieView.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
    }

