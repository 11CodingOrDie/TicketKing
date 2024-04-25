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
        ComingUpMoviePoster.addSubview(ComingUpMovieTitle)
        ComingUpMoviePoster.addSubview(ComingUpMovieGenre)
        ComingUpMoviePoster.addSubview(ComingUpMovieDirector)
        
    }
    
    private func setConstraint(){
        configurereleasedMovieViewConstaint()
    }
    
    //오토레이아웃 잡기
    private func configurereleasedMovieViewConstaint() {
        ComingUpMoviePoster.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ComingUpMoviePoster.topAnchor.constraint(equalTo: self.topAnchor, constant: 9),
            ComingUpMoviePoster.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11),
            ComingUpMoviePoster.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -258),
            ComingUpMoviePoster.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -9)
        ])
        
        ComingUpMovieTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ComingUpMovieTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 17), // myimage의 상단에 맞춤
            ComingUpMovieTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 100), // myimage의 왼쪽에 맞추고 간격 추가
            ComingUpMovieTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -175), // myimage의 오른쪽에 맞추고 간격 추가
            ComingUpMovieTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -49) // myimage의 하단에 맞춤
        ])
        
        ComingUpMovieGenre.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ComingUpMovieGenre.topAnchor.constraint(equalTo: self.topAnchor, constant: 48), // myimage의 상단에 맞춤
            ComingUpMovieGenre.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 100), // myimage의 왼쪽에 맞추고 간격 추가
            ComingUpMovieGenre.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18) // myimage의 하단에 맞춤
        ])
        
        ComingUpMovieDirector.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ComingUpMovieDirector.topAnchor.constraint(equalTo: self.topAnchor, constant: 48), // myimage의 상단에 맞춤
            ComingUpMovieDirector.leadingAnchor.constraint(equalTo: ComingUpMovieGenre.leadingAnchor, constant: 31), // myimage의 왼쪽에 맞추고 간격 추가
            ComingUpMovieDirector.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18) // myimage의 하단에 맞춤
        ])
    }
}
