//
//  PaymentMethodCollectionViewCell.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/26/24.
//

import UIKit
import SnapKit

class PaymentMethodCollectionViewCell: UICollectionViewCell {
//    static let identifier = "PaymentMethodCollectionViewCell"
    static let identifier = "PaymentMethodCollectionViewCell"
    
    let cardButton = UIButton(type: .custom)
    var buttonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(image: UIImage) {
        cardButton.setImage(image, for: .normal)
    }
    
    func configureUI() {
        contentView.addSubview(cardButton)
        
        cardButton.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalToSuperview()
        }
        
        cardButton.imageView?.contentMode = .scaleAspectFit
        cardButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    
    @objc private func buttonTapped() {
        // 버튼을 탭했을 때 수행할 동작
        buttonAction?()
    }
    
}
