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
    
    //cell에 들어갈 이미지 사이즈와 영역 설정
    private let releasedMovieSize = CGSize(width: 221, height: 279)
    private let releasedMovieView: UIImageView = {
        var imageview = UIImageView()
        imageview.layer.cornerRadius = 10
        imageview.backgroundColor = .gray
        return imageview
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
        self.addSubview(releasedMovieView)
    }
    
    private func setConstraint(){
        configurereleasedMovieViewConstaint()
    }
    
    //오토레이아웃 잡기
    private func configurereleasedMovieViewConstaint() {
        releasedMovieView.translatesAutoresizingMaskIntoConstraints = false //자동오토레이아웃 설정 끄기
        NSLayoutConstraint.activate([
            releasedMovieView.topAnchor.constraint(equalTo: self.topAnchor),
            releasedMovieView.widthAnchor.constraint(equalToConstant: releasedMovieSize.width),
            releasedMovieView.heightAnchor.constraint(equalToConstant: releasedMovieSize.height),
            releasedMovieView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    
    
    
    //url 불러와 설정해준 이미지 영역에 넣기
    func configure(with movie: MovieModel) {
        releasedMovieView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)"), placeholderImage: UIImage(named: "placeholder"))
    }
}
