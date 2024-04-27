//
//  CinemaTableViewCell.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/25/24.
//

import UIKit
import SnapKit

class CinemaTableViewCell: UITableViewCell {
    static let identifier = "CinemaTableViewCell"
    
    
//    let container = UIView()
    let cinemaName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
//        setupContainerView()
//        cinemaNameCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    private func setupContainerView() {
//        contentView.addSubview(container)
//        container.layer.cornerRadius = 8
//        container.clipsToBounds = true
//        container.backgroundColor = .white
//        container.snp.makeConstraints { make in
//            make.top.equalTo(contentView.snp.top).offset(8)
//            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
//            make.left.equalTo(contentView.snp.left).offset(16)
//            make.right.equalTo(contentView.snp.right).offset(-16)
//        }
//    }
//    
//    private func cinemaNameCell() {
////        cinemaNameCell = cinemaNameCell(frame: .zero)ㅣ
//        container.addSubview(cinemaNameCell)
//        cinemaNameCell.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
    
    func configureUI() {
        contentView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1) //rgba(220, 240, 238, 1)
        //        contentView.addSubview(container)
        contentView.addSubview(cinemaName)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5
        
        
        cinemaName.text = "티켓박스 신촌점"
        cinemaName.textColor = .black
        cinemaName.font = .systemFont(ofSize: 15, weight: .heavy)
        
        
        cinemaName.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(10)
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 26, bottom: 6, right: 26))
//        contentView.backgroundColor = .clear
    }
}

