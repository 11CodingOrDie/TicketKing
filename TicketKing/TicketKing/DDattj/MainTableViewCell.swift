//
//  MainTableViewCell.swift
//  TicketKing
//
//  Created by 이시안 on 4/25/24.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    //cell 식별자명 지정
    static let identifier = "MainTableViewCell"
    
    private let ComingUpMoviePoster: UIImageView = {
        var imageview = UIImageView()
        imageview.layer.cornerRadius = 5
        imageview.backgroundColor = .black
        return imageview
    }()
    
    private let ComingUpMovieTitle: UILabel = {
        var title = UILabel()
        title.text = "상영예정작"
        title.font = UIFont.systemFont(ofSize: 15)
        return title
    }()
    
    private let ComingUpMovieGenre: UILabel = {
        var genre = UILabel()
        genre.text = "장르"
        genre.font = UIFont.systemFont(ofSize: 13)
        return genre
    }()
    
    private let ComingUpMovieDirector: UILabel = {
        var director = UILabel()
        director.text = "감독"
        director.font = UIFont.systemFont(ofSize: 13)
        return director
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.addSubview(ComingUpMoviePoster)
        self.addSubview(ComingUpMovieTitle)
        self.addSubview(ComingUpMovieGenre)
        self.addSubview(ComingUpMovieDirector)
        
    }
    
    private func setConstraint(){
        configurereleasedMovieViewConstaint()
    }
    
    //오토레이아웃 잡기
    private func configurereleasedMovieViewConstaint() {
        ComingUpMoviePoster.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ComingUpMoviePoster.topAnchor.constraint(equalTo: self.topAnchor),
            ComingUpMoviePoster.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            ComingUpMoviePoster.widthAnchor.constraint(equalTo: self.widthAnchor),
            ComingUpMoviePoster.heightAnchor.constraint(equalToConstant: 279)
        ])
    }
}
