//
//  StarRatingView.swift
//  TicketKing
//
//  Created by David Jang on 4/27/24.
//

import Foundation
import UIKit

class StarRatingView: UIView {
    private let fullStars: Int
    private let totalStars = 5

    init(frame: CGRect, rating: Double) {
        // 별점을 정수로 변환 (5점 만점에서)
        self.fullStars = Int(rating / 2.0)
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let starPath = UIBezierPath()
        // 별 모양을 그립니다 - 이 예시에서는 간단한 원을 사용합니다.
        let diameter = rect.width / CGFloat(totalStars)
        for index in 0..<totalStars {
            let color = index < fullStars ? UIColor.yellow : UIColor.gray
            color.setFill()
            let xPosition = CGFloat(index) * diameter
            let circle = CGRect(x: xPosition, y: 0, width: diameter, height: diameter)
            starPath.append(UIBezierPath(ovalIn: circle))
        }
        starPath.fill()
    }
}
