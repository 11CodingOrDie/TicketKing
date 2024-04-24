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
        
        directorLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        directorLabel.textColor = .darkGray
        directorLabel.adjustsFontSizeToFitWidth = true
        directorLabel.minimumScaleFactor = 0.5
        directorLabel.numberOfLines = 1
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
        
        directorLabel.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(8)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with movie: MovieModel?) {
        imageView.isHidden = movie == nil
        titleLabel.isHidden = movie == nil
        genreLabel.isHidden = movie == nil || viewMode == .compact
        directorLabel.isHidden = movie == nil || viewMode == .compact
        
        if let movie = movie {
            titleLabel.text = movie.title
            imageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)"), placeholderImage: UIImage(named: "placeholder"))
            genreLabel.text = "장르: \(GenreManager.shared.genreNames(from: movie.genreIDS))"
            
            Task {
                if let directorName = DirectorManager.shared.directorName(for: movie.id) {
                    directorLabel.text = "감독: \(directorName)"
                } else {
                    await DirectorManager.shared.loadDirectorsAsync(movieId: movie.id)
                    DispatchQueue.main.async { [weak self] in
                        self?.directorLabel.text = "감독: \(DirectorManager.shared.directorName(for: movie.id) ?? "정보 없음")"
                    }
                }
            }
        }
    }
}
