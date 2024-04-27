//
//  BookingMovieViewController.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/26/24.
//

import UIKit
import SnapKit

struct SavedBookingData: Codable {
    let seat: String
    let date: String
    let time: String
}


class BookingMovieViewController: UIViewController {
    let dates = ["4월 29일", "4월 30일", "5월  1일", "5월  2일", "5월 3일", "5월 4일", "5월 6일", "5월  7일"]
    let times = ["09 : 00", "11 : 30", "13 : 00", "15 : 30", "18 : 00", "20 : 30", "23 : 00"]
    
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
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    var selectTimeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let lineView = UIView()
    let totalPriceLabel = UILabel()
    var selectedSeatCount = 0 {
        didSet {
            // selectedSeatCount 변수가 변경될 때마다 UILabel 업데이트
            
//            let totalPrice = selectedSeatCount * 10000
            totalPriceWonLabel.text = String((selectedSeatCount * 10000).formatted(.currency(code: "KRW")))
        }
    }
    let totalPriceWonLabel = UILabel()
    let moveToPayentPageButton = UIButton()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureUI()
        selectSeatCollectionView.delegate = self
        selectSeatCollectionView.dataSource = self
        selectDateCollectionView.dataSource = self
        selectDateCollectionView.delegate = self
        selectTimeCollectionView.dataSource = self
        selectTimeCollectionView.delegate = self
    }
    
    func setupConstraints() {
        view.addSubview(screenImageView)
        view.addSubview(selectSeatCollectionView)
        view.addSubview(bookingInfoImageView)
        bookingInfoImageView.addSubview(bookingLabel)
        bookingInfoImageView.addSubview(selectDateCollectionView)
        bookingInfoImageView.addSubview(selectTimeCollectionView)
        bookingInfoImageView.addSubview(lineView)
        bookingInfoImageView.addSubview(totalPriceLabel)
        bookingInfoImageView.addSubview(totalPriceWonLabel)
        bookingInfoImageView.addSubview(moveToPayentPageButton)
        
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
        
        selectTimeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectDateCollectionView.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(42)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(selectTimeCollectionView.snp.bottom).offset(31)
            make.centerX.equalToSuperview()
            make.width.equalTo(352)
            make.height.equalTo(1)
        }
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(24)
        }
        totalPriceWonLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalPriceLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-24)
        }
        moveToPayentPageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.height.equalTo(58)
            make.width.equalTo(344)
        }
    }

    func configureUI() {
        view.backgroundColor = .white
        
        selectSeatCollectionView.backgroundColor = .clear
        selectSeatCollectionView.register(SelectSeatCollectionViewCell.self, forCellWithReuseIdentifier: SelectSeatCollectionViewCell.identifier)
        selectSeatCollectionView.allowsMultipleSelection = true
        
        bookingLabel.text = "예약하기"
        bookingLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        //////////////////////////////////ㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗㅗ///////////////////////////////////////
        bookingInfoImageView.isUserInteractionEnabled = true
        
        selectDateCollectionView.backgroundColor = .clear
        selectDateCollectionView.register(SelectDateCollectionViewCell.self, forCellWithReuseIdentifier: SelectDateCollectionViewCell.identifier)
        selectDateCollectionView.allowsSelection = true
        
        selectTimeCollectionView.backgroundColor = .clear
        selectTimeCollectionView.register(SelectTimeCollectionViewCell.self, forCellWithReuseIdentifier: SelectTimeCollectionViewCell.identifier)
        selectTimeCollectionView.allowsSelection = true
        
        lineView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1)
        totalPriceLabel.text = "총 금액"
        totalPriceLabel.font = .systemFont(ofSize: 17, weight: .bold)
        totalPriceWonLabel.text = "0 원"
        totalPriceWonLabel.font = .systemFont(ofSize: 17, weight: .bold)
        moveToPayentPageButton.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.1490196078, blue: 0.1725490196, alpha: 1)
        moveToPayentPageButton.setTitle("결제창 이동", for: .normal)
        moveToPayentPageButton.layer.cornerRadius = 5
        moveToPayentPageButton.addTarget(self, action: #selector(checkMessageAlert), for: .touchUpInside)
        
    }
    @objc func checkMessageAlert() {
        let oklAlert = UIAlertController(title: "영화를 예매하시겠습니까?", message: "확인을 누를시 결제창으로 이동합니다", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "결제하기", style: .default) { action in
            self.moveToPayentPageButtonClicked()
        }
        oklAlert.addAction(cancelAction)
        oklAlert.addAction(okAction)
        self.present(oklAlert, animated: true)
    }
    
     func moveToPayentPageButtonClicked() {
        print("clicked button")
        let buyTicketPageViewController = BuyTicketPageViewController()
//        navigationController?.pushViewController(buyTicketPageViewController, animated: true) //navigationController 연결시
        buyTicketPageViewController.modalPresentationStyle = .fullScreen
        present(buyTicketPageViewController, animated: true, completion: nil)
    }

}



extension BookingMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == selectSeatCollectionView {
            return 35
        } 
        else if collectionView == selectDateCollectionView {
            return dates.count
        }
        else if collectionView == selectTimeCollectionView {
            return times.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            if collectionView == selectSeatCollectionView {
                guard let cell = selectSeatCollectionView.dequeueReusableCell(withReuseIdentifier: SelectSeatCollectionViewCell.identifier, for: indexPath) as? SelectSeatCollectionViewCell else { return UICollectionViewCell() }
                cell.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.5058823529, blue: 0.5411764706, alpha: 1)
                cell.layer.cornerRadius = 5
                return cell
            } 
            else if collectionView == selectDateCollectionView {
                guard let cell = selectDateCollectionView.dequeueReusableCell(withReuseIdentifier: SelectDateCollectionViewCell.identifier, for: indexPath) as? SelectDateCollectionViewCell else { return UICollectionViewCell() }
                
                cell.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1) //rgba(220, 240, 238, 1)
                cell.layer.cornerRadius = 25
                
               
                let datesLabel = UILabel(frame: cell.contentView.bounds)
                datesLabel.textAlignment = .center
                datesLabel.text = dates[indexPath.item]
                datesLabel.numberOfLines = 2

                cell.contentView.addSubview(datesLabel)
                return cell
            }
            else if collectionView == selectTimeCollectionView {
                guard let cell = selectTimeCollectionView.dequeueReusableCell(withReuseIdentifier: SelectTimeCollectionViewCell.identifier, for: indexPath) as? SelectTimeCollectionViewCell else { return UICollectionViewCell() }
                cell.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1) //rgba(220, 240, 238, 1)
                cell.layer.cornerRadius = 5
                
                let timeLabel = UILabel(frame: cell.contentView.bounds)
                timeLabel.textAlignment = .center
                timeLabel.text = times[indexPath.item]
                timeLabel.numberOfLines = 1
                cell.contentView.addSubview(timeLabel)
                return cell
            }
            return UICollectionViewCell()
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == selectSeatCollectionView {
            return CGSize(width: 38, height: 30)
        } 
        else if collectionView == selectDateCollectionView {
            return CGSize(width: 54, height: 80)
        }
        else if collectionView == selectTimeCollectionView {
            return CGSize(width: 76, height: 42)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == selectSeatCollectionView {
            print("좌석 \(indexPath.item)")
            selectedSeatCount += 1
        }
        else if collectionView == selectDateCollectionView {
            print(dates[indexPath.item])
        }
        else if collectionView == selectTimeCollectionView {
            print(times[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedSeatCount -= 1
    }
    // 좌석셀 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
}
