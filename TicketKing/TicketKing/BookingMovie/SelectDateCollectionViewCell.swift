//
//  SelectDateCollectionViewCell.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/26/24.
//

import UIKit
import SnapKit

class SelectDateCollectionViewCell: UICollectionViewCell {
    static let identifier = "SelectDateCollectionViewCell"
    
    let dateButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubview(dateButton)
        dateButton.backgroundColor = .red
    }
}
