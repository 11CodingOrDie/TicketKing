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
    var dateLabel = UILabel()
    let timeLabel = UILabel()
    lazy var movieInfoStackView = UIStackView(arrangedSubviews: [movieTitleLabel, genreLabel, dateLabel, timeLabel])
    let payingView = UIImageView(image: UIImage(named: "buyticketpage"))
    
    let bookingNumLabel = UILabel()
    let bookingRamdomNumLabel = UILabel()
    lazy var bookingNumStackView = UIStackView(arrangedSubviews: [bookingNumLabel, bookingRamdomNumLabel])
    

    let selectedSeatLabel = UILabel()
    let selectedSeatNumLabel = UILabel()
    lazy var seletedStackView = UIStackView(arrangedSubviews: [selectedSeatLabel, selectedSeatNumLabel])
    let separateLineView = UIView()

    let separateLineView2 = UIView()
    let totalPriceLabel = UILabel()
    let totalPriceWonLabel = UILabel()
    lazy var totalPriceStackView = UIStackView(arrangedSubviews: [totalPriceLabel, totalPriceWonLabel])
    lazy var bookingInfoStackView = UIStackView(arrangedSubviews: [seletedStackView, separateLineView, totalPriceStackView, separateLineView2])
    
    let payByLabel = UILabel()
    let payButton = UIButton()
    
    var paymentMethodCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 50
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    let images = ["bc", "citi", "hyundai", "kb", "lotte", "nh", "samsung", "sc", "uri"]
//    let images: [UIImage] = [UIImage(resource: .bc), UIImage(resource: .citi), UIImage(resource: .hyundai), UIImage(resource: .kb), UIImage(resource: .kb), UIImage(resource: .lotte), UIImage(resource: .nh), UIImage(resource: .samsung), UIImage(resource: .sc), UIImage(resource: .uri)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
        configureUI()
        
        paymentMethodCollectionView.delegate = self
        paymentMethodCollectionView.dataSource = self
        
    }
    
    func setupConstraints() {
        view.addSubview(posterImageView)
        view.addSubview(movieInfoStackView)
        view.addSubview(payingView)
        payingView.addSubview(bookingNumStackView)
        payingView.addSubview(bookingInfoStackView)
        payingView.addSubview(payByLabel)
        payingView.addSubview(payButton)
        payingView.addSubview(paymentMethodCollectionView)
       
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
        
    
        [seletedStackView, totalPriceLabel].forEach { view in
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
            make.top.equalTo(bookingNumStackView.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
            make.width.equalTo(341)
        }
        
        payByLabel.snp.makeConstraints { make in
            make.top.equalTo(bookingInfoStackView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(27)
        }
        
        paymentMethodCollectionView.snp.makeConstraints { make in
            make.top.equalTo(payByLabel.snp.bottom).offset(13)
            make.bottom.equalTo(payButton.snp.top).offset(-13)
            make.width.equalTo(346)
            make.centerX.equalToSuperview()
        }
        
        payButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.height.equalTo(60)
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
        
        
        payingView.isUserInteractionEnabled = true
        payByLabel.text = "결제방법"
        payByLabel.textColor = .black
        payByLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        paymentMethodCollectionView.backgroundColor = .white
        paymentMethodCollectionView.layer.cornerRadius = 5
        paymentMethodCollectionView.register(PaymentMethodCollectionViewCell.self, forCellWithReuseIdentifier: PaymentMethodCollectionViewCell.identifier)
        
        payButton.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.1490196078, blue: 0.1725490196, alpha: 1)
        payButton.setTitle("결제하기", for: .normal)
        payButton.layer.cornerRadius = 5
        
    }
}

extension BuyTicketPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = paymentMethodCollectionView.dequeueReusableCell(withReuseIdentifier: PaymentMethodCollectionViewCell.identifier, for: indexPath) as? PaymentMethodCollectionViewCell else { return UICollectionViewCell() }
        
        // 이미지 설정
//        guard let image = UIImage(named: images[indexPath.item]) else { return UICollectionViewCell() }
        let image = UIImage(named: images[indexPath.item])
        cell.setImage(image: image!)
        
        // 버튼에 액션 추가
        cell.buttonAction = {
            print("Button tapped at indexPath: \(indexPath)")
            // 선택된 셀의 인덱스 패스를 저장
                let selectedIndexPath = indexPath
                
                // 모든 셀에 대해 루프를 돌면서 테두리를 설정 혹은 초기화
            for index in 0..<collectionView.numberOfItems(inSection: indexPath.section) {
                let indexPath = IndexPath(item: index, section: indexPath.section)
                if let cell = collectionView.cellForItem(at: indexPath) {
                    if indexPath == selectedIndexPath {
                        // 선택된 셀의 경우 테두리 설정
                        cell.layer.borderWidth = 2.0
                        cell.layer.borderColor = UIColor.darkGray.cgColor // 테두리 색상 설정
                        cell.layer.cornerRadius = 5.0 // 테두리의 모서리를 둥글게 만듭니다. 선택사항입니다.
                    } else {
                        // 선택되지 않은 셀의 경우 테두리 초기화
                        cell.layer.borderWidth = 0.0
                        cell.layer.borderColor = nil
                        cell.layer.cornerRadius = 0.0
                    }
                }
            }
        }
        
        return cell
    }
}
    
