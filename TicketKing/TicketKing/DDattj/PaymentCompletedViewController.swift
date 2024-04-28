//
//  PaymentCompletedViewController.swift
//  TicketKing
//
//  Created by 이시안 on 4/28/24.
//

import UIKit

class PaymentCompletedViewController: UIViewController {
    
    //MARK: - 가져올 정보의 타입과 설정
    var movie: MovieModel?
    var selectedDate: String?
    var selectedTime: String?
    var selectedSeats: [String] = []
    
    //이미지 불러오기
    let movieBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        //이미지에 블러 넣기
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 블러 처리된 이미지 뷰를 이미지 뷰 위에 추가
        imageView.addSubview(blurEffectView)
        
        return imageView
    }()
    
    let movieThumbnail: UIImageView = {
        let thumbnailView = UIImageView()
        // UIView의 모서리를 둥글게 만듭니다.
        thumbnailView.layer.cornerRadius = 10
        thumbnailView.clipsToBounds = true
        thumbnailView.backgroundColor = .gray
        // UIImageView를 생성하여 UIView에 추가합니다.
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.frame = thumbnailView.bounds
        thumbnailView.addSubview(imageView)
        // 이미지 뷰의 오토레이아웃을 설정합니다.
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: thumbnailView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: thumbnailView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: thumbnailView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: thumbnailView.trailingAnchor).isActive = true
        return thumbnailView
    }()
    
    //글 불러오기
    let movieTitle: UILabel = {
        let label = UILabel()
        label.text = "1" //\(<#any Any.Type#>)
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .kDarkGreen
        return label
    }()
    
    let movieTheater: UILabel = {
        let label = UILabel()
        label.text = "1" //\(<#any Any.Type#>)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .kBlack
        return label
    }()
    
    let movieDate: UILabel = {
        let label = UILabel()
        label.text = "1" //\(<#any Any.Type#>)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .kBlack
        return label
    }()
    
    let movieTime: UILabel = {
        let label = UILabel()
        label.text = "1" //\(<#any Any.Type#>)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .kBlack
        return label
    }()
    
    let movieTheaterN: UILabel = {
        let label = UILabel()
        label.text = "1" //\(<#any Any.Type#>)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .kBlack
        return label
    }()
    
    let movieSeat: UILabel = {
        let label = UILabel()
        label.text = "1" //\(<#any Any.Type#>)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .kBlack
        label.numberOfLines = 4
        return label
    }()
    
    let moviePrice: UILabel = {
        let label = UILabel()
        label.text = "1" //\(<#any Any.Type#>)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .kBlack
        return label
    }()
    
    let movieNo: UILabel = {
        let label = UILabel()
        label.text = "1" //\(<#any Any.Type#>)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .kBlack
        return label
    }()
    
    //MARK: - 고정 설정
    
    let ticket: UIImageView = {
        let image = UIImageView(image: UIImage(named: "ticket"))
        return image
    }()
    
    let logoS: UIImageView = {
        let image = UIImageView(image: UIImage(named: "logoS"))
        return image
    }()
    
    let backButton: UIImageView = {
        let image = UIImageView(image: UIImage(named: "backB"))
        return image
    }()
    
    let subTitle1: UILabel = {
        let label = UILabel()
        label.text = "영화관"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .kGray
        return label
    }()
    
    let subTitle2: UILabel = {
        let label = UILabel()
        label.text = "상영날짜"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .kGray
        return label
    }()
    
    let subTitle3: UILabel = {
        let label = UILabel()
        label.text = "상영시간"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .kGray
        return label
    }()
    
    let subTitle4: UILabel = {
        let label = UILabel()
        label.text = "상영관"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .kGray
        return label
    }()
    
    let subTitle5: UILabel = {
        let label = UILabel()
        label.text = "예약좌석"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .kGray
        return label
    }()
    
    let subTitle6: UILabel = {
        let label = UILabel()
        label.text = "가격"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .kGray
        return label
    }()
    
//    let subTitle7: UILabel = {
//        let label = UILabel()
//        label.text = "예매번호"
//        label.font = UIFont.systemFont(ofSize: 13)
//        label.textColor = .kGray
//        return label
//    }()
    
    let barCode: UIImageView = {
        let image = UIImageView(image: UIImage(named: "barcode"))
        return image
    }()
    
    //MARK: - 기능 구현
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(movieBackground)
        view.addSubview(ticket)
        view.addSubview(movieThumbnail)
    
        view.addSubview(movieTitle)
        view.addSubview(movieTheater)
        view.addSubview(movieDate)
        view.addSubview(movieTime)
        view.addSubview(movieTheaterN)
        view.addSubview(movieSeat)
        view.addSubview(moviePrice)
        view.addSubview(movieNo)
        
        view.addSubview(barCode)
        view.addSubview(logoS)
        view.addSubview(backButton)
        view.addSubview(subTitle1)
        view.addSubview(subTitle2)
        view.addSubview(subTitle3)
        view.addSubview(subTitle4)
        view.addSubview(subTitle5)
        view.addSubview(subTitle6)
//        view.addSubview(subTitle7)
        setupNavigation()
        
        AutoLayoutD()
        AutoLayout()
        displayBookingDetails()
    }
    
    private func displayBookingDetails() {
        if let movie = movie {
            movieTitle.text = movie.title
//            genreLabel.text = GenreManager.shared.genreNames(from: movie.genreIDS)
            if let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
                movieBackground.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "placeholder"))
            } else {
                movieBackground.image = UIImage(named: "placeholder")
            }
            
            if let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
                movieThumbnail.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "placeholder"))
            } else {
                movieThumbnail.image = UIImage(named: "placeholder")
            }
            
            movieDate.text = selectedDate
            movieTime.text = selectedTime
            movieSeat.text = selectedSeats.joined(separator: ", ")
            let totalCost = selectedSeats.count * 10000  // 가정: 각 좌석 10,000원
            moviePrice.text = String((totalCost).formatted(.currency(code: "KRW")))
        }
    }
    
    
    private func setupNavigation() {
        self.title = "예매내역"
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func AutoLayout() {
        
        movieBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieBackground.topAnchor.constraint(equalTo: view.topAnchor),
            movieBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])

        movieThumbnail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieThumbnail.topAnchor.constraint(equalTo: view.topAnchor, constant: 154),
            movieThumbnail.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            movieThumbnail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            movieThumbnail.heightAnchor.constraint(equalToConstant: 139)
            
        ])
        
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 312),
            movieTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 74)
        ])
        
        movieTheater.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieTheater.topAnchor.constraint(equalTo: view.topAnchor, constant: 387),
            movieTheater.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 74)
        ])
        
        movieDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieDate.topAnchor.constraint(equalTo: view.topAnchor, constant: 451),
            movieDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 74)
        ])
        
        movieTime.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieTime.topAnchor.constraint(equalTo: view.topAnchor, constant: 451),
            movieTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 233)
        ])
        
        movieTheaterN.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieTheaterN.topAnchor.constraint(equalTo: view.topAnchor, constant: 515),
            movieTheaterN.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 74)
        ])
        
        movieSeat.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieSeat.topAnchor.constraint(equalTo: subTitle5.bottomAnchor, constant: 1),
            movieSeat.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 233),
            movieSeat.trailingAnchor.constraint(equalTo: ticket.trailingAnchor, constant: -20),
            movieSeat.bottomAnchor.constraint(equalTo: moviePrice.bottomAnchor)
        ])
        
        moviePrice.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviePrice.topAnchor.constraint(equalTo: view.topAnchor, constant: 579),
            moviePrice.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 74)
        ])
        
        movieNo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieNo.topAnchor.constraint(equalTo: view.topAnchor, constant: 579),
            movieNo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 233)
        ])
    }
    
    func AutoLayoutD() {
        ticket.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ticket.topAnchor.constraint(equalTo: view.topAnchor, constant: 122),
            ticket.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            ticket.widthAnchor.constraint(equalToConstant: 330),
            ticket.heightAnchor.constraint(equalToConstant: 632)
        ])
        
        logoS.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoS.topAnchor.constraint(equalTo: view.topAnchor, constant: 785),
            logoS.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 128),
            logoS.widthAnchor.constraint(equalToConstant: 138),
            logoS.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        barCode.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barCode.topAnchor.constraint(equalTo: view.topAnchor, constant: 643),
            barCode.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            barCode.widthAnchor.constraint(equalToConstant: 230),
            barCode.heightAnchor.constraint(equalToConstant: 83)
        ])
        
        
        subTitle1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitle1.topAnchor.constraint(equalTo: view.topAnchor, constant: 362),
            subTitle1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 74)
        ])
        
        subTitle2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitle2.topAnchor.constraint(equalTo: view.topAnchor, constant: 426),
            subTitle2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 74)
        ])
        
        subTitle3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitle3.topAnchor.constraint(equalTo: view.topAnchor, constant: 426),
            subTitle3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 233)
        ])
        
        subTitle4.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitle4.topAnchor.constraint(equalTo: view.topAnchor, constant: 490),
            subTitle4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 74)
        ])
        
        subTitle5.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitle5.topAnchor.constraint(equalTo: view.topAnchor, constant: 490),
            subTitle5.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 233)
        ])
        
        subTitle6.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitle6.topAnchor.constraint(equalTo: view.topAnchor, constant: 554),
            subTitle6.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 74)
        ])
        
//        subTitle7.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            subTitle7.topAnchor.constraint(equalTo: view.topAnchor, constant: 554),
//            subTitle7.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 233)
//        ])
    }
}


