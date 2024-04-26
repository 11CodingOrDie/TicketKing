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
    lazy var bookingNumStackView = UIStackView(arrangedSubviews: [bookingNumLabel, bookingRamdomNumLabel])
    

    let selectedSeatLabel = UILabel()
    let selectedSeatNumLabel = UILabel()
    lazy var seletedStackView = UIStackView(arrangedSubviews: [selectedSeatLabel, selectedSeatNumLabel])
    let separateLineView = UIView()
    let discountLabel = UILabel()
    let discountPriceLabel = UILabel()
    lazy var discountStackView = UIStackView(arrangedSubviews: [discountLabel, discountPriceLabel])
    let separateLineView2 = UIView()
    let totalPriceLabel = UILabel()
    let totalPriceWonLabel = UILabel()
    lazy var totalPriceStackView = UIStackView(arrangedSubviews: [totalPriceLabel, totalPriceWonLabel])
    lazy var bookingInfoStackView = UIStackView(arrangedSubviews: [seletedStackView, separateLineView, discountStackView, separateLineView2, totalPriceStackView])
    
    let payByLabel = UILabel()
    
    let payButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
        configureUI()
        
    }
    
    func setupConstraints() {
        view.addSubview(posterImageView)
        view.addSubview(movieInfoStackView)
        view.addSubview(payingView)
        payingView.addSubview(bookingNumStackView)
        payingView.addSubview(bookingInfoStackView)
        payingView.addSubview(payByLabel)
        payingView.addSubview(payButton)
       
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
        
        bookingNumStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(27)
        }
        
    
        [seletedStackView, discountStackView, totalPriceLabel].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(60)
            }
        }

        [separateLineView, separateLineView2].forEach { line in
            line.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        }
        
        bookingInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(bookingNumStackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(341)
        }
        
        payByLabel.snp.makeConstraints { make in
            make.top.equalTo(bookingInfoStackView.snp.bottom).offset(38)
            make.leading.equalToSuperview().offset(27)
        }
        
        payButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.height.equalTo(58)
            make.width.equalTo(344)
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
        
        bookingNumStackView.spacing = 8
        bookingNumStackView.axis = .horizontal
        bookingNumStackView.distribution = .fillEqually
        bookingNumStackView.alignment = .fill
        
        selectedSeatLabel.text = "선택 좌석"
        selectedSeatLabel.textColor = .black
        selectedSeatLabel.font = .systemFont(ofSize: 15, weight: .medium)
        selectedSeatNumLabel.text = "0000, 0000"
        selectedSeatNumLabel.textColor = .black
        selectedSeatNumLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        seletedStackView.axis = .horizontal
        
        separateLineView.backgroundColor = .white
        
        discountLabel.text = "할인 적용"
        discountLabel.textColor = .black
        discountLabel.font = .systemFont(ofSize: 15, weight: .medium)
        discountPriceLabel.text = " - 000 원"
        discountPriceLabel.textColor = .black
        discountPriceLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        discountStackView.axis = .horizontal
        
        separateLineView2.backgroundColor = .white
        
        totalPriceLabel.text = "총 금액"
        totalPriceLabel.textColor = .black
        totalPriceLabel.font = .systemFont(ofSize: 15, weight: .medium)
        totalPriceWonLabel.text = "10,000 원"
        totalPriceWonLabel.textColor = .red
        totalPriceWonLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        totalPriceStackView.axis = .horizontal
        
        bookingInfoStackView.axis = .vertical
        bookingInfoStackView.alignment = .fill
        bookingInfoStackView.backgroundColor = .clear
        
        payByLabel.text = "결제방법"
        payByLabel.textColor = .black
        payByLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        payButton.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.1490196078, blue: 0.1725490196, alpha: 1)
        payButton.setTitle("결제하기", for: .normal)
        payButton.layer.cornerRadius = 5
        
    }
    
}
    
