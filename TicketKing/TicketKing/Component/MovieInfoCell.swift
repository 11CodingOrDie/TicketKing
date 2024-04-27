//
//  MovieInfoCell.swift
//  TicketKing
//
//  Created by David Jang on 4/24/24.
//

import UIKit
import SnapKit
import SDWebImage

class MovieInfoCell: UIView {
    
    enum ViewMode {
        case compact  // 포스터 이미지만 표시
        case full     // 포스터 이미지, 영화 제목, 장르
    }
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    var viewMode: ViewMode = .full
    
    init(frame: CGRect, movie: MovieModel? = nil, mode: ViewMode = .full) {
        super.init(frame: frame)
        self.viewMode = mode
        setupViews()
        setupConstraints()
        configure(with: movie)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(genreLabel)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
        
        genreLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        genreLabel.textColor = .darkGray
        genreLabel.adjustsFontSizeToFitWidth = true
        genreLabel.minimumScaleFactor = 0.5
        genreLabel.numberOfLines = 1
    }
    
    private func setupConstraints() {
        backgroundColor = UIColor(red: 0.863, green: 0.941, blue: 0.933, alpha: 1)
        layer.cornerRadius = 5
        clipsToBounds = true
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        if viewMode == .full {
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.top)
                make.left.equalTo(imageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-16)
            }
            
            genreLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.left.equalTo(imageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-10)
            }
        }
    }
    
    func configure(with movie: MovieModel?) {
        imageView.isHidden = movie == nil
        titleLabel.isHidden = movie == nil || viewMode == .compact
        genreLabel.isHidden = movie == nil || viewMode == .compact
        
        if let movie = movie {
            imageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)"), placeholderImage: UIImage(named: "placeholder"))
            
            if viewMode == .full {
                titleLabel.text = movie.title
                genreLabel.text = "장르: \(GenreManager.shared.genreNames(from: movie.genreIDS))"
            }
        }
    }
}
