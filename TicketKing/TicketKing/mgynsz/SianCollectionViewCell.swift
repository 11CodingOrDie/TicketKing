//
//  SianCollectionViewCell.swift
//  TicketKing
//
//  Created by David Jang on 4/24/24.
//

import UIKit

class SianCollectionViewCell: UICollectionViewCell {
    
    // Cell 식별자명 지정
    static let identifier = "SianViewController"
    
    // Cell에 들어갈 이미지 영역 설정
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill // 이미지가 뷰의 크기에 맞춰 채워지도록 설정
        imageView.clipsToBounds = true // 이미지가 뷰를 넘어서지 않도록 클리핑
        imageView.layer.cornerRadius = 10 // 모서리를 둥글게 처리
        imageView.backgroundColor = .gray // 로딩 전 배경 색상 설정
        return imageView
    }()
    
    // 이 클래스를 사용하기 위한 초기화 함수들
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 구성을 위한 메서드
    private func setupUI() {
        contentView.addSubview(movieImageView) // 콘텐츠 뷰에 이미지 뷰 추가
    }
    
    // 오토레이아웃 제약 조건 설정
    private func setupConstraints() {
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    // 영화 데이터를 셀에 설정
    func configure(with movie: MovieModel) {
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
            movieImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
    }
}
