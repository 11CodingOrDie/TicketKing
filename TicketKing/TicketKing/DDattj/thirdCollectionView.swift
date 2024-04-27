//
//  thirdCollectionView.swift
//  TicketKing
//
//  Created by 이시안 on 4/26/24.
//

import UIKit
import SnapKit

class thirdCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "thirdCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        // 이미지뷰 추가
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150) // 이미지의 높이 지정
        }
        
        // 타이틀 레이블 추가
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8) // 이미지 아래에 배치
            make.leading.trailing.equalToSuperview().inset(1)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(with movie: MovieModel) {
        titleLabel.text = movie.title // 영화의 타이틀 설정
        
        // 포스터 이미지 설정
        if !movie.posterPath.isEmpty {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
}
