//
//  DetailPageViewController.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/23/24.
//

import UIKit
import SnapKit

class DetailPageViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
        
    let posterImageView = UIImageView(image: UIImage(named: "jerry"))
    let detailView = UIView()
    let movieTitleLabel = UILabel()
    let releaseYearLabel = UILabel()
    let genreLabel = UILabel()
    
    let directorInfoView = UIView()
    let directorImageView = UIImageView(image: UIImage(named: "jerry"))
    let directorLabel = UILabel()
    let directorNameLabel = UILabel()
    lazy var directorStackView = UIStackView(arrangedSubviews: [directorLabel, directorNameLabel])
    let movieDescription = UILabel()
    let movieDescriptionLabel = UILabel()
    let actorLabel = UILabel()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureUI()
        loadData()
//
    }
    
    func setupConstraints() { // addSubview, 오토레이아웃 등
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(detailView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(releaseYearLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(directorInfoView)
        directorInfoView.addSubview(directorImageView)
        directorInfoView.addSubview(directorStackView)
        contentView.addSubview(movieDescription)
        contentView.addSubview(movieDescriptionLabel)
        contentView.addSubview(actorLabel)
        contentView.addSubview(collectionView)
        
 
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(700)
        }
        
        detailView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(-30)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(detailView.snp.top).offset(20)
            make.leading.equalTo(detailView.snp.leading).offset(20)
        }
        
        releaseYearLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(detailView.snp.leading).offset(20)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.leading.equalTo(releaseYearLabel.snp.trailing).offset(10)
            make.centerY.equalTo(releaseYearLabel.snp.centerY)
        }
        
        directorInfoView.snp.makeConstraints { make in
            make.top.equalTo(releaseYearLabel.snp.bottom).offset(20)
            make.leading.equalTo(detailView.snp.leading).offset(16)
            make.trailing.equalTo(detailView.snp.trailing).offset(-16)
            make.height.equalTo(76)
        }
        
        directorImageView.snp.makeConstraints { make in
            make.top.equalTo(directorInfoView.snp.top).offset(10)
            make.bottom.equalTo(directorInfoView.snp.bottom).offset(-10)
            make.leading.equalTo(directorInfoView.snp.leading).offset(16)
            make.width.equalTo(55)
        }
        
        directorStackView.snp.makeConstraints { make in
            make.leading.equalTo(directorImageView.snp.trailing).offset(10)
            make.centerY.equalTo(directorImageView.snp.centerY)
        }
        
        movieDescription.snp.makeConstraints { make in
            make.top.equalTo(directorInfoView.snp.bottom).offset(30)
            make.leading.equalTo(directorInfoView.snp.leading)
        }
        
        movieDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(movieDescription.snp.bottom).offset(20)
            make.leading.equalTo(movieDescription.snp.leading)
            make.trailing.equalTo(directorInfoView.snp.trailing)
        }
        
        actorLabel.snp.makeConstraints { make in
            make.top.equalTo(movieDescriptionLabel.snp.bottom).offset(30)
            make.leading.equalTo(movieDescriptionLabel.snp.leading)
            make.bottom.equalToSuperview()
            
        }
    }
    
    func configureUI() { // UI 요소들의 속성을 대입(컬러, text 등)
        posterImageView.backgroundColor = .orange
        
        detailView.backgroundColor = .gray
        detailView.layer.cornerRadius = 15
        detailView.alpha = 0.5
        
        movieTitleLabel.text = "영화제목"
        movieTitleLabel.textColor = .white
        movieTitleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        
        directorInfoView.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.337254902, blue: 0.3254901961, alpha: 1)
        directorInfoView.layer.cornerRadius = 5
        directorInfoView.clipsToBounds = true
        
        directorImageView.backgroundColor = .yellow
        directorImageView.layer.cornerRadius = 5
        directorImageView.clipsToBounds = true
        
        releaseYearLabel.text = "년도"
        releaseYearLabel.textColor = .white
        
        genreLabel.text = "장르"
        genreLabel.textColor = .white
        
        directorLabel.text = "감독"
        directorLabel.textColor = .white
        
        directorNameLabel.text = "감독이름"
        directorNameLabel.textColor = .white
        
        directorStackView.spacing = 3
        directorStackView.axis = .vertical
        directorStackView.distribution = .fillEqually
        directorStackView.alignment = .fill
        
        movieDescription.text = "영화 설명"
        movieDescription.textColor = .white
        movieDescription.font = .systemFont(ofSize: 17, weight: .semibold)
        
        movieDescriptionLabel.text = "영화설명 영화설명 영화설명 영화설명 영화설명 영화설명 영화설명 영화설명 영화설명"
        movieDescriptionLabel.textColor = .white
        movieDescriptionLabel.font = .systemFont(ofSize: 15, weight: .medium)
        movieDescriptionLabel.numberOfLines = 0
        
        actorLabel.text = "배우"
        actorLabel.textColor = .white
        actorLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: ActorCollectionViewCell.identify)
//        collectionView.collectionViewLayout.scro
        

    }
    
    func loadData() {
        Task {
            do {
                let nowPlayingMovies = try await MovieManager.shared.fetchMovies(endpoint: "now_playing", page: 1, language: "ko-KR")
                print("success")
                if let sampleMovie = nowPlayingMovies.results.randomElement() {
                    updateData(sampleMovie)
                }
            } catch {
                print("failed")
                print("failed error \(error)")
            }
        }
    }
    
    func updateData(_ movie: MovieModel) {
        movieTitleLabel.text = movie.title
        releaseYearLabel.text = movie.releaseDate
        movieDescriptionLabel.text = movie.overview
    }
}

extension DetailPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorCollectionViewCell.identify, for: indexPath) as? ActorCollectionViewCell else { return UICollectionViewCell()}
        
        return cell
    }
    
}
