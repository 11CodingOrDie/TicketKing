//
//  BuyTicketPageViewController.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/26/24.
//

import UIKit
import SnapKit

class BuyTicketPageViewController: UIViewController {

    let posterImageView = UIImageView()
    let movieTitleLabel = UILabel()
    let genreLabel = UILabel()
    let cinemaLabel = UILabel()
    let dateLabel = UILabel()
    let timeLabel = UILabel()
    lazy var movieInfoStackView = UIStackView(arrangedSubviews: [movieTitleLabel, genreLabel, cinemaLabel, dateLabel, timeLabel])
    let payingView = UIImageView(image: UIImage(named: "buyticketpage"))
    
    let bookingNumLabel = UILabel()
    let bookingRamdomNumLabel = UILabel()
    lazy var bookinNumStackView = UIStackView(arrangedSubviews: [bookingNumLabel, bookingRamdomNumLabel])
    
    let totalPriceTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
        configureUI()
        
    }
    
    func setupConstraints() {
        view.addSubview(posterImageView)
        view.addSubview(movieInfoStackView)
        view.addSubview(payingView)
        payingView.addSubview(bookinNumStackView)
        payingView.addSubview(totalPriceTableView)
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(147)
            make.width.equalTo(98)
        }
        
        movieInfoStackView.snp.makeConstraints { make in
            make.centerY.equalTo(posterImageView)
            make.leading.equalTo(posterImageView.snp.trailing).offset(20)
        }
        
        payingView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(18)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        bookinNumStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(27)
        }
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        posterImageView.backgroundColor = .red
        
        movieTitleLabel.text = "영화제목"
        movieTitleLabel.textColor = #colorLiteral(red: 0.07450980392, green: 0.4117647059, blue: 0.4, alpha: 1) //rgba(19, 105, 102, 1)
        movieTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        genreLabel.text = "장르"
        genreLabel.textColor = #colorLiteral(red: 0.537254902, green: 0.5058823529, blue: 0.5411764706, alpha: 1) //rgba(137, 129, 138, 1)
        genreLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
        cinemaLabel.text = "선택 영화관"
        cinemaLabel.textColor = .black
        cinemaLabel.font = .systemFont(ofSize: 15, weight: .semibold)

        dateLabel.text = "0000.00.00"
        dateLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 13, weight: .medium)

        timeLabel.text = "00:00"
        timeLabel.textColor = .black
        timeLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
        movieInfoStackView.spacing = 6
        movieInfoStackView.axis = .vertical
        movieInfoStackView.distribution = .fillEqually
        movieInfoStackView.alignment = .fill
        
        bookingNumLabel.text = "예매번호 : "
        bookingNumLabel.textColor = .white
        bookingNumLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        bookingRamdomNumLabel.text = String(Int.random(in: 1...9999999))
        bookingRamdomNumLabel.textColor = .white
        
        bookinNumStackView.spacing = 8
        bookinNumStackView.axis = .horizontal
        bookinNumStackView.distribution = .fillEqually
        bookinNumStackView.alignment = .fill
    }
    
}
    
}
