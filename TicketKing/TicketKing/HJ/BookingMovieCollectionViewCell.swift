//
//  SelectSeatCollectionViewCell.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/26/24.
//

import UIKit
import SnapKit

class SelectSeatCollectionViewCell: UICollectionViewCell {
    static let identifier = "SelectSeatCollectionViewCell"
    let selectButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
      didSet {
        if isSelected {
            backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.1490196078, blue: 0.1725490196, alpha: 1) //rgba(233, 38, 44, 1)
        } else {
            backgroundColor = #colorLiteral(red: 0.537254902, green: 0.5058823529, blue: 0.5411764706, alpha: 1) //rgba(137, 129, 138, 1)
        }
      }
    }
    
    
//    func configureUI() {
//        contentView.addSubview(selectButton)
//        
//        selectButton.backgroundColor = .green
//    }
}

//class SelectDateCollectionViewCell: UICollectionViewCell {
//    static let identifier = "SelectDateCollectionViewCell"
//    
//    let dateLabel = UILabel()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//  
//    override var isSelected: Bool {
//      didSet {
//        if isSelected {
//            backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.6039215686, blue: 0.5450980392, alpha: 1) //rgba(26, 154, 139, 1)
//        } else {
//            backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1) //rgba(220, 240, 238, 1)
//        }
//      }
//    }
//    
//    func configureUI() {
//        addSubview(dateLabel)
//        dateLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//        dateLabel.textColor = .black
//        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        dateLabel.numberOfLines = 2  // 두 줄로 설정
//        dateLabel.textAlignment = .center
//    }
//    
//}

class SelectDateCollectionViewCell: UICollectionViewCell {
    static let identifier = "SelectDateCollectionViewCell"
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        layer.cornerRadius = 25
        layer.masksToBounds = true
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? #colorLiteral(red: 0.1019607843, green: 0.6039215686, blue: 0.5450980392, alpha: 1) : #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1)
        }
    }
}


class SelectTimeCollectionViewCell: UICollectionViewCell {
    static let identifier = "SelectTimeCollectionViewCell"

    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

  
    override var isSelected: Bool {
      didSet {
        if isSelected {
            backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.6039215686, blue: 0.5450980392, alpha: 1) //rgba(26, 154, 139, 1)
        } else {
            backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1) //rgba(220, 240, 238, 1)
        }
      }
    }

    
}
