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
//    let detailView = UIView()
    let detailView = UIImageView(image: UIImage(named: "Vector"))
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
    
    var actorListColletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        return cv
    }()
    
    let choiceCinemaLabel = UILabel()
//    let cinemaTableView = UITableView()
    let choiceCinemaButton = UIButton()
    let choiceCinemaButton2 = UIButton()
    let choiceCinemaButton3 = UIButton()
    
    let bottomView = UIView()
    let buyTicketButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureUI()
        loadData()

        actorListColletionView.delegate = self
        actorListColletionView.dataSource = self
        
//        cinemaTableView.delegate = self
//        cinemaTableView.dataSource = self
    }
    
    func setupConstraints() { // addSubview, 오토레이아웃 등
        view.addSubview(bottomView)
        bottomView.addSubview(buyTicketButton)
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
        contentView.addSubview(actorListColletionView)
        contentView.addSubview(choiceCinemaLabel)
        contentView.addSubview(choiceCinemaButton)
        contentView.addSubview(choiceCinemaButton2)
        contentView.addSubview(choiceCinemaButton3)
//        contentView.addSubview(cinemaTableView)
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view)
            make.height.equalTo(100)
        }
        
        buyTicketButton.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(70)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(bottomView.snp.top)
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
            make.top.equalTo(posterImageView.snp.centerY)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(detailView.snp.top).offset(35)
            make.leading.equalTo(detailView.snp.leading).offset(26)
        }
        
        releaseYearLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(9)
            make.leading.equalTo(detailView.snp.leading).offset(26)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseYearLabel.snp.top)
            make.leading.equalTo(releaseYearLabel.snp.trailing).offset(14)
            make.centerY.equalTo(releaseYearLabel.snp.centerY)
        }
        
        directorInfoView.snp.makeConstraints { make in
            make.top.equalTo(releaseYearLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(76)
            make.width.equalTo(342)
        }
        
        directorImageView.snp.makeConstraints { make in
            make.top.equalTo(directorInfoView.snp.top).offset(10)
            make.bottom.equalTo(directorInfoView.snp.bottom).offset(-10)
            make.leading.equalTo(directorInfoView.snp.leading).offset(14)
            make.width.equalTo(55)
        }
        
        directorStackView.snp.makeConstraints { make in
            make.leading.equalTo(directorImageView.snp.trailing).offset(14)
            make.centerY.equalTo(directorImageView.snp.centerY)
        }
        
        movieDescription.snp.makeConstraints { make in
            make.top.equalTo(directorInfoView.snp.bottom).offset(32)
            make.leading.equalTo(directorInfoView.snp.leading)
        }
        
        movieDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(movieDescription.snp.bottom).offset(10)
            make.leading.equalTo(movieDescription.snp.leading)
            make.trailing.equalTo(directorInfoView.snp.trailing)
        }
        
        actorLabel.snp.makeConstraints { make in
            make.top.equalTo(movieDescriptionLabel.snp.bottom).offset(32)
            make.leading.equalTo(movieDescriptionLabel.snp.leading)
        }
        
        actorListColletionView.snp.makeConstraints { make in
            make.top.equalTo(actorLabel.snp.bottom).offset(6)
            make.leading.equalTo(actorLabel.snp.leading)
            make.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        choiceCinemaLabel.snp.makeConstraints { make in
            make.top.equalTo(actorListColletionView.snp.bottom).offset(35)
            make.leading.equalTo(actorLabel.snp.leading)
        }
        
//        cinemaTableView.snp.makeConstraints { make in
//            make.top.equalTo(choiceCinemaLabel.snp.bottom).offset(10)
//            make.leading.trailing.equalToSuperview()
//            make.bottom.equalToSuperview()
//            
//            make.height.equalTo(300)
//        }
        
        choiceCinemaButton.snp.makeConstraints { make in
            make.top.equalTo(choiceCinemaLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(341)
        }
        
        choiceCinemaButton2.snp.makeConstraints { make in
            make.top.equalTo(choiceCinemaButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(341)
        }
        
        choiceCinemaButton3.snp.makeConstraints { make in
            make.top.equalTo(choiceCinemaButton2.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(341)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configureUI() { // UI 요소들의 속성을 대입(컬러, text 등)
        posterImageView.backgroundColor = .orange
        
//        detailView.backgroundColor = .gray
//        detailView.layer.cornerRadius = 15
//        detailView.alpha = 0.5
        
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
        directorLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
        directorNameLabel.text = "감독이름"
        directorNameLabel.textColor = .white
        directorNameLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
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
        
        actorListColletionView.backgroundColor = .clear
        actorListColletionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: ActorCollectionViewCell.identifier)
        
        
        choiceCinemaLabel.text = "영화관 선택"
        choiceCinemaLabel.textColor = .black
        choiceCinemaLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
//        cinemaTableView.register(CinemaTableViewCell.self, forCellReuseIdentifier: CinemaTableViewCell.identifier)
//        cinemaTableView.backgroundColor = .clear
//        cinemaTableView.separatorStyle = .none
        
        bottomView.backgroundColor = #colorLiteral(red: 0.5490196078, green: 0.8039215686, blue: 0.7725490196, alpha: 1) //rgba(140, 205, 197, 1)
        
        buyTicketButton.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.1490196078, blue: 0.1725490196, alpha: 1) //rgba(233, 38, 44, 1)
        buyTicketButton.setTitle("예매하기", for: .normal)
        buyTicketButton.layer.cornerRadius = 5
        
        choiceCinemaButton.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1)
        choiceCinemaButton.setTitle("티켓박스 내일점", for: .normal)
        choiceCinemaButton.layer.cornerRadius = 5
        choiceCinemaButton.setTitleColor(.black, for: .normal)
        
        choiceCinemaButton2.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1)
        choiceCinemaButton2.setTitle("티켓박스 배움점", for: .normal)
        choiceCinemaButton2.layer.cornerRadius = 5
        choiceCinemaButton2.setTitleColor(.black, for: .normal)
        
        choiceCinemaButton3.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1)
        choiceCinemaButton3.setTitle("티켓박스 캠프점", for: .normal)
        choiceCinemaButton3.layer.cornerRadius = 5
        choiceCinemaButton3.setTitleColor(.black, for: .normal)

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

extension DetailPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = actorListColletionView.dequeueReusableCell(withReuseIdentifier: ActorCollectionViewCell.identifier, for: indexPath) as? ActorCollectionViewCell else { return UICollectionViewCell() }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let width = actorListColletionView.frame.width
        //        let height = actorListColletionView.frame.height
        //
        //        return CGSize(width: width, height: height)
        return CGSize(width: 125, height: 57)
    }
}

//extension DetailPageViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = cinemaTableView.dequeueReusableCell(withIdentifier: CinemaTableViewCell.identifier, for: indexPath) as? CinemaTableViewCell else { return UITableViewCell() }
//        cell.selectionStyle = .none
//        cell.clipsToBounds = true
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//}
