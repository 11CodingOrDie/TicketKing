//
//  ActorCollectionViewCell.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/24/24.
//

import UIKit
import SnapKit
import SDWebImage

class ActorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ActorCollectionViewCell"
    
    private let actorProfileImage = UIImageView()
    private let firstNameLabel = UILabel()
    private let lastNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
//        self.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1)
//        self.layer.cornerRadius = 5
        
        contentView.addSubview(actorProfileImage)
        contentView.addSubview(firstNameLabel)
        contentView.addSubview(lastNameLabel)
        
        actorProfileImage.contentMode = .scaleAspectFill
        actorProfileImage.layer.cornerRadius = 16
        actorProfileImage.layer.borderWidth = 2
        actorProfileImage.layer.borderColor = UIColor(named: "kOlive")?.cgColor
        actorProfileImage.layer.shadowColor = UIColor.black.cgColor
        actorProfileImage.clipsToBounds = true
        
        firstNameLabel.textColor = .black
        firstNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        firstNameLabel.numberOfLines = 2
        firstNameLabel.textAlignment = .center
        
        lastNameLabel.textColor = .darkGray
        lastNameLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        lastNameLabel.numberOfLines = 2
        lastNameLabel.textAlignment = .center
        
        actorProfileImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.8)
        }
        
        firstNameLabel.snp.makeConstraints { make in
            make.top.equalTo(actorProfileImage.snp.bottom).offset(4)
            make.centerX.equalToSuperview()  // centerX를 사용하여 중앙 정렬
            make.left.right.equalToSuperview().inset(4)
        }
        
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()  // centerX를 사용하여 중앙 정렬
            make.left.right.equalToSuperview().inset(4)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(with castMember: CastMember) {
        let components = castMember.name.components(separatedBy: " ")
        if components.count > 1 {
            firstNameLabel.text = components.first
            lastNameLabel.text = components.dropFirst().joined(separator: " ")
        } else {
            firstNameLabel.text = castMember.name
            lastNameLabel.text = "" // empty if there's no last name
        }

        if let profilePath = castMember.profilePath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)") {
            actorProfileImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            actorProfileImage.image = UIImage(named: "placeholder") // Default placeholder image if no URL
        }
    }
}
