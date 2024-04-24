//
//  MovieInfoCell.swift
//  TicketKing
//
//  Created by David Jang on 4/24/24.
//

import UIKit
import SnapKit

class MovieInfoCell: UIView {
    
    enum ViewMode {
        case compact  // 컬렉션뷰용
        case full     // 테이블뷰용
    }
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    private let directorLabel = UILabel()
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
        addSubview(directorLabel)
        
        // 기본 설정
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.isHidden = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
        titleLabel.isHidden = true
        
        genreLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        genreLabel.textColor = .darkGray
        genreLabel.adjustsFontSizeToFitWidth = true
        genreLabel.minimumScaleFactor = 0.5
        genreLabel.numberOfLines = 1
        genreLabel.isHidden = true
        
        directorLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        directorLabel.textColor = .darkGray
        directorLabel.adjustsFontSizeToFitWidth = true
        directorLabel.minimumScaleFactor = 0.5
        directorLabel.numberOfLines = 1
        directorLabel.isHidden = true
        
    }
    
    private func setupConstraints() {
        
        self.backgroundColor = UIColor(red: 0.863, green: 0.941, blue: 0.933, alpha: 1)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            //            make.width.height.equalTo(70)
            make.width.equalTo(imageView.snp.height)
            make.height.equalToSuperview().multipliedBy(0.8)
            //            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            //            make.top.equalToSuperview().offset(10)
            make.top.equalTo(imageView.snp.top)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-16)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        directorLabel.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(8)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with movie: MovieModel?) {
        if let movie = movie {
            // 공통으로 보일 정보
            imageView.isHidden = false
            titleLabel.isHidden = false
            
            // compact 숨길 정보
            genreLabel.isHidden = viewMode == .compact
            directorLabel.isHidden = viewMode == .compact
            
            titleLabel.text = movie.title
            
            if !movie.posterPath.isEmpty {
                let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                imageView.image = UIImage(named: "placeholder")
            }

            if viewMode == .full {
                genreLabel.text = "장르: \(GenreManager.shared.genreNames(from: movie.genreIDS))"
                directorLabel.text = "인기지수: \(movie.popularity)"
            }
        } else {
            imageView.isHidden = true
            titleLabel.isHidden = true
            genreLabel.isHidden = true
            directorLabel.isHidden = true
        }
    }
}

