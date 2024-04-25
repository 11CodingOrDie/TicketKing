//
//  MainCollectionViewCell.swift
//  TicketKing
//
//  Created by 이시안 on 4/23/24.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    //cell 식별자명 지정
    static let identifier = "MainCollectionViewCell"
    
    private let releasedMoviePoster: UIImageView = {
        var imageview = UIImageView()
        imageview.layer.cornerRadius = 10
        imageview.backgroundColor = .gray
        return imageview
    }()
    
    private let releasedMovieTitle: UILabel = {
        var title = UILabel()
        title.text = "제목"
        title.font = UIFont.systemFont(ofSize: 16)
        return title
    }()
    
    private let releasedMovieGenre: UILabel = {
        var genre = UILabel()
        genre.text = "장르"
        genre.font = UIFont.systemFont(ofSize: 15)
        return genre
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.addSubview(releasedMoviePoster)
        self.addSubview(releasedMovieTitle)
        self.addSubview(releasedMovieGenre)
    }
    
    private func setConstraint(){
        configurereleasedMovieViewConstaint()
    }
    
    //오토레이아웃 잡기
    private func configurereleasedMovieViewConstaint() {
        releasedMoviePoster.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releasedMoviePoster.topAnchor.constraint(equalTo: self.topAnchor),
            releasedMoviePoster.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            releasedMoviePoster.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            releasedMoviePoster.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        releasedMovieTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releasedMovieTitle.centerXAnchor.constraint(equalTo: releasedMoviePoster.centerXAnchor), // releasedMovieView의 중앙과 정렬
            releasedMovieTitle.bottomAnchor.constraint(equalTo: releasedMoviePoster.bottomAnchor, constant: 30) // releasedMovieView의 세로 중앙과 정렬
        ])
        
        releasedMovieGenre.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releasedMovieGenre.centerXAnchor.constraint(equalTo: releasedMoviePoster.centerXAnchor), // releasedMovieView의 중앙과 정렬
            releasedMovieGenre.bottomAnchor.constraint(equalTo: releasedMoviePoster.bottomAnchor, constant: 50), // releasedMovieView의 세로 중앙과 정렬
        ])
    }
}
