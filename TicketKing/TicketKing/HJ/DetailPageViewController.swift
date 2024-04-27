//
//  DetailPageViewController.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/23/24.
//

import UIKit
import SnapKit
import SDWebImage

class DetailPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let posterImageView = UIImageView()
    let detailView = UIImageView()
    let movieTitleLabel = UILabel()
    let releaseYearLabel = UILabel()
    let genreLabel = UILabel()
    
    let directorInfoView = UIView()
    let directorImageView = UIImageView()
    let directorLabel = UILabel()
    let directorNameLabel = UILabel()
    lazy var directorStackView = UIStackView(arrangedSubviews: [directorLabel, directorNameLabel])
    let movieDescription = UILabel()
    let movieDescriptionLabel = UILabel()
    let actorLabel = UILabel()
    
    var actorListColletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        return cv
    }()
    
    let choiceCinemaLabel = UILabel()
    let choiceCinemaButton = UIButton()
    let choiceCinemaButton2 = UIButton()
    let choiceCinemaButton3 = UIButton()
    
    let bottomView = UIView()
    let buyTicketButton = UIButton()
    
    var movie: MovieModel? {
        didSet {
            updateUI()
            
        }
    }
    
    private var castMembers: [CastMember] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(contentView)
//        setupPosterImageView()
//        setupScrollView()
        configureUI()
//        setupNavigationBar()
        setupConstraints()
        
        actorListColletionView.delegate = self
        actorListColletionView.dataSource = self
        configureCollectionView()
        
    }
    
//    private func setupPosterImageView() {
//        posterImageView.contentMode = .scaleAspectFill
//        posterImageView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.leading.trailing.equalTo(view)
//            make.height.equalTo(view.snp.height).multipliedBy(0.5)
//        }
//    }
    
//    private func setupScrollView() {
//        scrollView.snp.makeConstraints { make in
//            make.top.equalTo(posterImageView.snp.bottom)
//            make.leading.trailing.bottom.equalTo(view)
//        }
//        contentView.snp.makeConstraints { make in
//            make.edges.equalTo(scrollView)
//            make.width.equalTo(scrollView)
//        }
//    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func registerCells() {
        actorListColletionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: ActorCollectionViewCell.identifier)
    }

    func updateUI() {
        guard let movie = movie else { return }
        DispatchQueue.main.async {
            self.movieTitleLabel.text = movie.title
            self.releaseYearLabel.text = movie.releaseDate
            self.movieDescriptionLabel.text = movie.overview
            self.posterImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)"), placeholderImage: UIImage(named: "placeholder"))
        }
        loadDirectorAndCastData()
    }

    private func loadDirectorAndCastData() {
        guard let movieId = movie?.id else { return }
        
        Task {
            await DirectorManager.shared.loadDirectorsAsync(movieId: movieId)
            
            // Load cast details
            CastManager.shared.loadCast(for: movieId) { [weak self] castMembers in
                guard let self = self, let castMembers = castMembers else { return }
                self.castMembers = castMembers
                DispatchQueue.main.async {
                    self.actorListColletionView.reloadData()
                }
            }
            
            // Update UI on the main thread
            DispatchQueue.main.async {
                if let directorDetails = DirectorManager.shared.directorDetails(for: movieId) {
                    self.directorNameLabel.text = "감독: \(directorDetails.name)"
                    if let profilePath = directorDetails.profilePath {
                        self.directorImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)"), placeholderImage: UIImage(named: "placeholder"))
                    }
                }
            }
        }
    }



    private func configureCollectionView() {
        actorListColletionView.delegate = self
        actorListColletionView.dataSource = self
        actorListColletionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: ActorCollectionViewCell.identifier)
    }

    func setupConstraints() { // addSubview, 오토레이아웃 등
//        view.addSubview(bottomView)
        bottomView.addSubview(buyTicketButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(detailView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(releaseYearLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(directorInfoView)
        directorInfoView.addSubview(directorImageView)
        directorInfoView.addSubview(directorStackView)
        contentView.addSubview(movieDescription)
        contentView.addSubview(movieDescriptionLabel)
        contentView.addSubview(actorLabel)
        contentView.addSubview(actorListColletionView)
        contentView.addSubview(choiceCinemaLabel)
        contentView.addSubview(choiceCinemaButton)
        contentView.addSubview(choiceCinemaButton2)
        contentView.addSubview(choiceCinemaButton3)
        
//        bottomView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(view)
//            make.height.equalTo(100)
//        }
        
        buyTicketButton.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
//        posterImageView.snp.makeConstraints { make in
//                make.top.equalTo(view.safeAreaLayoutGuide.snp.top) // 안전 영역 상단에 고정
//                make.leading.equalTo(view.snp.leading) // 뷰의 왼쪽 끝에 맞춤
//                make.trailing.equalTo(view.snp.trailing) // 뷰의 오른쪽 끝에 맞춤
////                make.height.equalTo(700) // 높이를 700으로 설정
//            }
//            
//            posterImageView.contentMode = .scaleToFill // 이미지를 프레임에 맞게 조정
//        
        detailView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.centerY)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(detailView.snp.top).offset(35)
            make.leading.equalTo(detailView.snp.leading).offset(26)
        }
        
        releaseYearLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(9)
            make.leading.equalTo(detailView.snp.leading).offset(26)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseYearLabel.snp.top)
            make.leading.equalTo(releaseYearLabel.snp.trailing).offset(14)
            make.centerY.equalTo(releaseYearLabel.snp.centerY)
        }
        
        directorInfoView.snp.makeConstraints { make in
            make.top.equalTo(releaseYearLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(76)
            make.width.equalTo(342)
        }
        
        directorImageView.snp.makeConstraints { make in
            make.top.equalTo(directorInfoView.snp.top).offset(10)
            make.bottom.equalTo(directorInfoView.snp.bottom).offset(-10)
            make.leading.equalTo(directorInfoView.snp.leading).offset(14)
            make.width.equalTo(55)
        }
        
        directorStackView.snp.makeConstraints { make in
            make.leading.equalTo(directorImageView.snp.trailing).offset(14)
            make.centerY.equalTo(directorImageView.snp.centerY)
        }
        
        movieDescription.snp.makeConstraints { make in
            make.top.equalTo(directorInfoView.snp.bottom).offset(32)
            make.leading.equalTo(directorInfoView.snp.leading)
        }
        
        movieDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(movieDescription.snp.bottom).offset(10)
            make.leading.equalTo(movieDescription.snp.leading)
            make.trailing.equalTo(directorInfoView.snp.trailing)
        }
        
        actorLabel.snp.makeConstraints { make in
            make.top.equalTo(movieDescriptionLabel.snp.bottom).offset(32)
            make.leading.equalTo(movieDescriptionLabel.snp.leading)
        }
        
        actorListColletionView.snp.makeConstraints { make in
            make.top.equalTo(actorLabel.snp.bottom).offset(6)
            make.leading.equalTo(actorLabel.snp.leading)
            make.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        choiceCinemaLabel.snp.makeConstraints { make in
            make.top.equalTo(actorListColletionView.snp.bottom).offset(35)
            make.leading.equalTo(actorLabel.snp.leading)
        }
        
        choiceCinemaButton.snp.makeConstraints { make in
            make.top.equalTo(choiceCinemaLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(341)
        }
        
        choiceCinemaButton2.snp.makeConstraints { make in
            make.top.equalTo(choiceCinemaButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(341)
        }
        
        choiceCinemaButton3.snp.makeConstraints { make in
            make.top.equalTo(choiceCinemaButton2.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(341)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configureUI() { // UI 요소들의 속성을 대입(컬러, text 등)
        
        movieTitleLabel.textColor = .white
        movieTitleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        
//        directorInfoView.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.5058823529, blue: 0.5411764706, alpha: 1)
//        directorInfoView.layer.cornerRadius = 5
//        directorInfoView.clipsToBounds = true
//        directorImageView.backgroundColor = .yellow
//        directorImageView.layer.cornerRadius = 5
//        directorImageView.clipsToBounds = true
        
        releaseYearLabel.textColor = .white
        
        genreLabel.textColor = .white
        
        directorLabel.textColor = .white
        directorLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
        directorNameLabel.textColor = .white
        directorNameLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
        directorStackView.spacing = 3
        directorStackView.axis = .vertical
        directorStackView.distribution = .fillEqually
        directorStackView.alignment = .fill
        
        movieDescription.textColor = .white
        movieDescription.font = .systemFont(ofSize: 17, weight: .semibold)
        
        movieDescriptionLabel.textColor = .white
        movieDescriptionLabel.font = .systemFont(ofSize: 15, weight: .medium)
        movieDescriptionLabel.numberOfLines = 0
        
        actorLabel.textColor = .white
        actorLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        actorListColletionView.backgroundColor = .clear
        actorListColletionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: ActorCollectionViewCell.identifier)
        actorListColletionView.showsHorizontalScrollIndicator = false
        
//        choiceCinemaLabel.text = "영화관 선택"
//        choiceCinemaLabel.textColor = .black
//        choiceCinemaLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        bottomView.backgroundColor = #colorLiteral(red: 0.5490196078, green: 0.8039215686, blue: 0.7725490196, alpha: 1) //rgba(140, 205, 197, 1)
        
        buyTicketButton.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.1490196078, blue: 0.1725490196, alpha: 1) //rgba(233, 38, 44, 1)
        buyTicketButton.setTitle("예매하기", for: .normal)
        buyTicketButton.layer.cornerRadius = 5.5
        buyTicketButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
//        choiceCinemaButton.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1)
//        choiceCinemaButton.setTitle("티켓박스 내일점", for: .normal)
//        choiceCinemaButton.layer.cornerRadius = 5
//        choiceCinemaButton.setTitleColor(.black, for: .normal)
//        
//        choiceCinemaButton2.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1)
//        choiceCinemaButton2.setTitle("티켓박스 배움점", for: .normal)
//        choiceCinemaButton2.layer.cornerRadius = 5
//        choiceCinemaButton2.setTitleColor(.black, for: .normal)
//        
//        choiceCinemaButton3.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.9411764706, blue: 0.9333333333, alpha: 1)
//        choiceCinemaButton3.setTitle("티켓박스 캠프점", for: .normal)
//        choiceCinemaButton3.layer.cornerRadius = 5
//        choiceCinemaButton3.setTitleColor(.black, for: .normal)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castMembers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorCollectionViewCell.identifier, for: indexPath) as? ActorCollectionViewCell else {
            return UICollectionViewCell()
        }
        let castMember = castMembers[indexPath.row]
        cell.configure(with: castMember)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 200) // 적절한 셀 크기 조정
    }
}

