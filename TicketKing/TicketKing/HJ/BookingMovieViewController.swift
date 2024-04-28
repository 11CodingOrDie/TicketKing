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
    
    var availableDates = [String]()
    let dateFormatter = DateFormatter()
//    let dates = ["4월 29일", "4월 30일", "5월  1일", "5월  2일", "5월 3일", "5월 4일", "5월 6일", "5월  7일"]
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 20)
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
   
    
    let totalPriceWonLabel = UILabel()
    let moveToPaymentPageButton = UIButton()
    

    var movie: MovieModel?
    var selectedDate: String?
    var selectedTime: String?
//    var selectedSeats: [String] = []
    
    var selectedSeats: [String] = [] {
        didSet {
            totalPriceWonLabel.text = String((selectedSeats.count * 10000).formatted(.currency(code: "KRW")))
            updateMoveToPaymentButtonState()
        }
    }
    
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
        updateUIWithMovieInfo()
        setupNavigation()
        setupMoveToPaymentPageButton()
        updateMoveToPaymentButtonState()
        fetchMovieDates()
    }
    
    func fetchMovieDates() {
        dateFormatter.dateFormat = "yyyy-MM-dd"  // dateFormatter 설정
        Task {
            do {
                let movies = try await MovieManager.shared.fetchNowPlayingMovies2()
                if let dates = movies.dates {
                    print("Fetched movie dates: \(dates)")
                    generateDateRange(from: dates.minimum, to: dates.maximum)
                }
            } catch {
                print("Error fetching movies: \(error)")
            }
        }
    }

    func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        if let startDate = dateFormatter.date(from: availableDates.first ?? ""),
           let endDate = dateFormatter.date(from: availableDates.last ?? "") {
            datePicker.minimumDate = startDate
            datePicker.maximumDate = endDate
        }
        // datePicker를 UI에 추가하는 코드 필요
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        dateFormatter.dateFormat = "MM월 dd일"
        self.selectedDate = dateFormatter.string(from: selectedDate)
    }
    
    func saveSelections() {
        let data = SavedBookingData(seat: selectedSeats.joined(separator: ","), date: selectedDate ?? "", time: selectedTime ?? "")
        UserDefaults.standard.set(try? PropertyListEncoder().encode(data), forKey: "SavedBooking")
    }

    func restoreSelections() {
        if let data = UserDefaults.standard.value(forKey: "SavedBooking") as? Data,
           let savedData = try? PropertyListDecoder().decode(SavedBookingData.self, from: data) {
            selectedSeats = savedData.seat.components(separatedBy: ",")
            selectedDate = savedData.date
            selectedTime = savedData.time
            // UI 업데이트 로직 필요
        }
    }
    
    func generateDateRange(from startDate: String, to endDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let start = dateFormatter.date(from: startDate),
              let end = dateFormatter.date(from: endDate),
              let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) else { return }
        
        var currentDate = start > today ? start : today  // 시작 날짜가 오늘보다 이전이면 오늘로 설정
        while currentDate <= end {
            dateFormatter.dateFormat = "MM월\ndd일"  // 날짜 형식 변경
            let formattedDate = dateFormatter.string(from: currentDate)
            availableDates.append(formattedDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        DispatchQueue.main.async {
            self.selectDateCollectionView.reloadData()
        }
    }
    
    func updateMoveToPaymentButtonState() {
        moveToPaymentPageButton.isEnabled = !(selectedSeats.isEmpty || selectedDate == nil || selectedTime == nil)
        moveToPaymentPageButton.alpha = moveToPaymentPageButton.isEnabled ? 1.0 : 0.5
    }
    
    private func setupMoveToPaymentPageButton() {
        moveToPaymentPageButton.addTarget(self, action: #selector(moveToPaymentTapped), for: .touchUpInside)
    }
    
    private func updateUIWithMovieInfo() {
        guard let movie = movie else { return }
        // 여기에서 영화 정보를 바탕으로 UI 요소를 업데이트
        // 예: navigationItem.title = movie.title
        print("예매를 시작합니다: \(movie.title)")
    }
    
    private func setupNavigation() {
        self.title = "예매 선택"
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left.circle"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
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
        bookingInfoImageView.addSubview(moveToPaymentPageButton)
        
        screenImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(110)
            make.centerX.equalToSuperview()
        }
        
        selectSeatCollectionView.snp.makeConstraints { make in
            make.top.equalTo(screenImageView.snp.bottom).offset(16)
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
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        selectTimeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectDateCollectionView.snp.bottom).offset(25)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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
        moveToPaymentPageButton.snp.makeConstraints { make in
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
        moveToPaymentPageButton.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.1490196078, blue: 0.1725490196, alpha: 1)
        moveToPaymentPageButton.setTitle("결제창 이동", for: .normal)
        moveToPaymentPageButton.layer.cornerRadius = 5
//        moveToPaymentPageButton.addTarget(self, action: #selector(checkMessageAlert), for: .touchUpInside)
        
    }
    
    private func setupmoveToPayentPageButton() {
        moveToPaymentPageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.height.equalTo(58)
            make.width.equalTo(344)
        }
        moveToPaymentPageButton.addTarget(self, action: #selector(moveToPaymentTapped), for: .touchUpInside)
    }

    @objc private func moveToPaymentTapped() {
        let paymentVC = BuyTicketPageViewController()
        paymentVC.movie = movie
        paymentVC.selectedDate = selectedDate
        paymentVC.selectedTime = selectedTime
        paymentVC.selectedSeats = selectedSeats
        let navController = UINavigationController(rootViewController: paymentVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
     func moveToPayentPageButtonClicked() {
        print("clicked button")
        let buyTicketPageViewController = BuyTicketPageViewController()
        navigationController?.pushViewController(buyTicketPageViewController, animated: true) //navigationController 연결시
//        buyTicketPageViewController.modalPresentationStyle = .fullScreen
//        present(buyTicketPageViewController, animated: true, completion: nil)
    }

}



extension BookingMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == selectSeatCollectionView {
            return 35
        } 
        else if collectionView == selectDateCollectionView {
            return availableDates.count
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectDateCollectionViewCell.identifier, for: indexPath) as? SelectDateCollectionViewCell else { return UICollectionViewCell() }
            cell.dateLabel.text = availableDates[indexPath.item]
            cell.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1)
            return cell
        }
        else if collectionView == selectTimeCollectionView {
            guard let cell = selectTimeCollectionView.dequeueReusableCell(withReuseIdentifier: SelectTimeCollectionViewCell.identifier, for: indexPath) as? SelectTimeCollectionViewCell else { return UICollectionViewCell() }
            cell.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1)
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
            return CGSize(width: 80, height: 80)
        }
        else if collectionView == selectTimeCollectionView {
            return CGSize(width: 76, height: 42)
        }
        return CGSize(width: 0, height: 0)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == selectSeatCollectionView {
            print("좌석 \(indexPath.item)")
            selectedSeats.append("Seat \(indexPath.item + 1)") // 좌석 번호 추가
            updateMoveToPaymentButtonState()
        } else if collectionView == selectDateCollectionView {
            selectedDate = availableDates[indexPath.item]
            updateMoveToPaymentButtonState()
        } else if collectionView == selectTimeCollectionView {
            selectedTime = times[indexPath.item]
            updateMoveToPaymentButtonState()
        }
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == selectSeatCollectionView {
            selectedSeats.removeAll { $0 == "Seat \(indexPath.item + 1)" } // 선택 해제된 좌석 제거
            updateMoveToPaymentButtonState()
        }
    }
    // 좌석셀 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
}
