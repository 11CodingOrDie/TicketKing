//
//  MovieCardCell.swift
//  TicketKing
//
//  Created by David Jang on 4/24/24.
//

import Foundation
import UIKit
import SnapKit

class MovieCardCell: UIView {
    
    enum ViewMode {
        case collectionCard
        case listCard
    }
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    var viewMode: ViewMode = .collectionCard
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.viewMode = mode
        setupViews()
        setupConstraints()
//        configure(with: movie)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(genreLabel)

        // 기본 설정
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.isHidden = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
        titleLabel.isHidden = true
        
        genreLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        genreLabel.textColor = .darkGray
        genreLabel.adjustsFontSizeToFitWidth = true
        genreLabel.minimumScaleFactor = 0.5
        genreLabel.numberOfLines = 1
        genreLabel.isHidden = true
        
    }
    
    private func setupConstraints() {
        
//        self.layer.cornerRadius = 5
//        self.clipsToBounds = true
        
        imageView.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(8)
////            make.centerX.equalToSuperview()
//            make.height.equalTo(280)
//            make.width.equalTo(220)
//            //            make.width.height.equalTo(70)
////            make.width.equalTo(imageView.snp.height)
////            make.height.equalToSuperview().multipliedBy(0.8)
//                        make.height.equalTo(imageView.snp.width)
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(imageView.snp.width).multipliedBy(1.3)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            //            make.top.equalToSuperview().offset(10)
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalTo(imageView.snp.centerX)
            make.left.greaterThanOrEqualToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview().offset(-16)
//            make.left.right.equalToSuperview().inset(16)
//            make.left.equalTo(imageView.snp.right).offset(10)
//            make.right.equalToSuperview().offset(-16)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalTo(imageView.snp.centerX)
//            make.left.right.equalToSuperview().inset(16)
            make.left.greaterThanOrEqualToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview().offset(-16)
//            make.left.equalTo(imageView.snp.right).offset(10)
//            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with movie: MovieModel?, mode: ViewMode) {
        
        self.viewMode = mode
        
        if let movie = movie {
            imageView.isHidden = false
            titleLabel.isHidden = false
            
            genreLabel.isHidden = (mode == .listCard)
            
            titleLabel.text = movie.title
            
            if !movie.posterPath.isEmpty {
                let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                imageView.image = UIImage(named: "placeholder")
            }

            if mode == .collectionCard {
                genreLabel.text = "장르: \(GenreManager.shared.genreNames(from: movie.genreIDS))"
            }
        } else {
            imageView.isHidden = true
            titleLabel.isHidden = true
            genreLabel.isHidden = true
        }
    }
}
