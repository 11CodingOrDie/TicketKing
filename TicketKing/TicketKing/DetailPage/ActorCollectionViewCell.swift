//
//  ActorCollectionViewCell.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/24/24.
//

import UIKit
import SnapKit

class ActorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ActorCollectionViewCell"
    
    let actorProfileImage = UIImageView()
    let actorNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.backgroundColor = .red
        self.layer.cornerRadius = 5
        
        contentView.addSubview(actorProfileImage)
        contentView.addSubview(actorNameLabel)
        
        
        actorProfileImage.backgroundColor = .gray
        actorProfileImage.layer.cornerRadius = 5
        actorNameLabel.text = "배우이름"
        actorNameLabel.textColor = .white
        
        actorProfileImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
        }
        
        actorNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(actorProfileImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(actorProfileImage.snp.centerY)
        }
    }
    
}
