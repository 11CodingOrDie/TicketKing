//
//  BookingMovieViewController.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/26/24.
//

import UIKit
import SnapKit

class BookingMovieViewController: UIViewController {

    let screenImageView = UIImageView(image: UIImage(named: "screen"))
    var selectSeatCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let bookingInfoImageView = UIImageView(image: UIImage(named: "booking"))
    let bookingLabel = UILabel()
    
    var selectDateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let dates = ["4월 22일", "4월 23일", "4월 24일", "4월 25일", "4월 26일"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureUI()
        
        
        selectSeatCollectionView.delegate = self
        selectSeatCollectionView.dataSource = self
        
        selectDateCollectionView.dataSource = self
        selectDateCollectionView.delegate = self
    }
    
    func setupConstraints() {
        view.addSubview(screenImageView)
        view.addSubview(selectSeatCollectionView)
        view.addSubview(bookingInfoImageView)
        bookingInfoImageView.addSubview(bookingLabel)
        bookingInfoImageView.addSubview(selectDateCollectionView)
        
        
        screenImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        selectSeatCollectionView.snp.makeConstraints { make in
            make.top.equalTo(screenImageView.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(200)
        }
        
        bookingInfoImageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        bookingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(42)
            make.centerX.equalToSuperview()
        }
        
        selectDateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(bookingLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(27)
            make.trailing.equalToSuperview().offset(-27)
            make.height.equalTo(80)
        }
    }

    func configureUI() {
        view.backgroundColor = .white
        
        selectSeatCollectionView.backgroundColor = .clear
        selectSeatCollectionView.register(SelectSeatCollectionViewCell.self, forCellWithReuseIdentifier: SelectSeatCollectionViewCell.identifier)
        selectSeatCollectionView.allowsMultipleSelection = true
        
        bookingLabel.text = "예약하기"
        bookingLabel.font = .systemFont(ofSize: 17, weight: .regular)
        
        //////////////////////////////////ㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗ///////////////////////////////////////
        bookingInfoImageView.isUserInteractionEnabled = true
        
        selectDateCollectionView.backgroundColor = .clear
        selectDateCollectionView.register(SelectDateCollectionViewCell.self, forCellWithReuseIdentifier: SelectDateCollectionViewCell.identifier)
        selectDateCollectionView.allowsSelection = true
    }
}

extension BookingMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == selectSeatCollectionView {
            return 35
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            if collectionView == selectSeatCollectionView {
                guard let cell = selectSeatCollectionView.dequeueReusableCell(withReuseIdentifier: SelectSeatCollectionViewCell.identifier, for: indexPath) as? SelectSeatCollectionViewCell else { return UICollectionViewCell() }
                cell.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.5058823529, blue: 0.5411764706, alpha: 1)
                cell.layer.cornerRadius = 5
                return cell
            } else {
                guard let cell = selectDateCollectionView.dequeueReusableCell(withReuseIdentifier: SelectDateCollectionViewCell.identifier, for: indexPath) as? SelectDateCollectionViewCell else { return UICollectionViewCell() }
                
                cell.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1) //rgba(220, 240, 238, 1)
                cell.layer.cornerRadius = 25
                
                cell.isUserInteractionEnabled = true
                // 날짜 선택
                let datesLabel = UILabel(frame: cell.contentView.bounds)
                datesLabel.textAlignment = .center
                datesLabel.text = dates[indexPath.item]
                datesLabel.numberOfLines = 2
//                
////                let buyPoint = UITapGestureRecognizer(target: self, action: #selector(clickPoint(_:)))
////                datesLabel.isUserInteractionEnabled = true
////                datesLabel.addGestureRecognizer(buyPoint)
////    
                cell.contentView.addSubview(datesLabel)
                return cell
            }
        
    }
    
    @objc func clickPoint(_ sender: Any) {
           print("clickPoint")
       }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == selectSeatCollectionView {
            return CGSize(width: 38, height: 30)
        } else {
            return CGSize(width: 54, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == selectSeatCollectionView {
            print("좌석")
        } else {
            print("왜안돼")
        }
    }
    
}
