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
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubview(selectButton)
        
        selectButton.backgroundColor = .green
    }
}
