//
//  MovieViewController.swift
//  TicketKing
//
//  Created by 이시안 on 4/25/24.
//

import Foundation
import UIKit

class MovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var releasedMovies: [MovieModel] = [] // 현재상영작 상세 정보 배열
    var upcomingMovies: [MovieModel] = [] // 상영예정작 상세 정보 배열
    var searchMovies: [MovieModel] = [] // 검색 시 나타나는 영화 정보 배열
    
    //세그먼트컨트롤로 보여줄 정보 화면
    lazy var segMovies: UISegmentedControl = {
        let segment = UISegmentedControl()
        //백그라운드 제거, 구분선 제거
        segment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        //선택 안됐을때 폰트
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.kBlack,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)
        ], for: .normal)
        // 선택된 버튼 폰트
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.kBlack, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)], for: .selected)//폰트 설정
        //세그먼트 타이틀
        segment.insertSegment(withTitle: "현재상영작", at: 0, animated: true)
        segment.insertSegment(withTitle: "상영예정작", at: 1, animated: true)
        segment.addTarget(self, action: #selector(changeUnderLinePosition), for: .valueChanged)
        return segment
    }()
    
    var underLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    
    private let title1: UILabel = {
        let label = UILabel()
        label.text = "영화 선택"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    
    
    
    var firstCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }() //콜렉션뷰는 선언하자마자 바로 플로우레이아웃 식을 적어줘야 한다
    var secondCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    var thirdCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(title1)
        
        view.addSubview(segMovies)
        view.addSubview(underLineView)
        underLineView.backgroundColor = .kRed
        changeUnderLinePosition()
//        setSegment()
        
        setupfirstCollectionView()
        setupSecondCollectionView()
        setupThirdCollectionView()
        addMoviesToCollectionView()
        fetchReleasedMovies()
        fetchUpcomingMovies()
        fetchAllMovies()
        
        setSearchBar()
        autoLayout()
    }
    
    
    private func fetchReleasedMovies(language: String = "ko-KR", page: Int = 1) {
        Task {
            do {
                let moviesList = try await MovieManager.shared.fetchNowPlayingMovies(page: page, language: language)
                self.releasedMovies = moviesList
                DispatchQueue.main.async {
                    self.firstCollectionView.reloadData()
                }
            } catch {
                print("Error fetching popular movies: \(error)")
            }
        }
    }
    
    // 상영 예정 영화 데이터 가져오기
    private func fetchUpcomingMovies(language: String = "ko-KR", page: Int = 1) {
        Task {
            do {
                let moviesList = try await MovieManager.shared.fetchUpcomingMovies(page: page, language: language)
                self.upcomingMovies = moviesList
                DispatchQueue.main.async {
                    self.secondCollectionView.reloadData()
                }
            } catch {
                print("Error fetching upcoming movies: \(error)")
            }
        }
    }
    
    //전체데이터 가지고 오기
    private func fetchAllMovies(language: String = "ko-KR", page: Int = 1) {
        Task {
            do {
                let moviesList = try await MovieManager.shared.fetchPopularMovies(page: page, language: language)
                self.searchMovies = moviesList
                DispatchQueue.main.async {
                    self.thirdCollectionView.reloadData()
                }
            } catch {
                print("Error fetching all movies: \(error)")
            }
        }
    }
    
    
    
    private func addMoviesToCollectionView() {
        firstCollectionView.reloadData()
        secondCollectionView.reloadData()
        thirdCollectionView.reloadData()
    }
    
    
    
    
    // 첫 번째 CollectionView 설정
    private func setupfirstCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        firstCollectionView.register(firstCollectionViewCell.self, forCellWithReuseIdentifier: firstCollectionViewCell.identifier)
        firstCollectionView.dataSource = self
        firstCollectionView.delegate = self
        view.addSubview(firstCollectionView)
    }
    
    // 두 번째 CollectionView 설정
    private func setupSecondCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        secondCollectionView.register(secondCollectionViewCell.self, forCellWithReuseIdentifier: secondCollectionViewCell.identifier)
        secondCollectionView.dataSource = self
        secondCollectionView.delegate = self
        view.addSubview(secondCollectionView)
    }
    
    // 세 번째 CollectionView 설정
    private func setupThirdCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        thirdCollectionView.register(thirdCollectionViewCell.self, forCellWithReuseIdentifier: thirdCollectionViewCell.identifier)
        thirdCollectionView.dataSource = self
        thirdCollectionView.delegate = self
        view.addSubview(thirdCollectionView)
    }
    
    
    
    
    //각 뷰에 보여질 정보 연결
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === firstCollectionView {
            return releasedMovies.count
        } else if collectionView === secondCollectionView {
            return upcomingMovies.count
        } else {
            return searchMovies.count
        }
    }
    
    //각 콜렉션뷰와 콜렉션셀 연결해주기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === firstCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCollectionViewCell", for: indexPath) as? firstCollectionViewCell else {
                fatalError("Unable to dequeue firstCollectionViewCell")
            }
            cell.configure(with: releasedMovies[indexPath.row])
            return cell
        } else if collectionView === secondCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCollectionViewCell", for: indexPath) as? secondCollectionViewCell else {
                fatalError("Unable to dequeue secondCollectionViewCell")
            }
            cell.configure(with: upcomingMovies[indexPath.row])
            return cell
        } else {
            // Third CollectionView 설정
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thirdCollectionViewCell", for: indexPath) as? thirdCollectionViewCell else {
                fatalError("Unable to dequeue thirdCollectionViewCell")
            }
            cell.configure(with: searchMovies[indexPath.row])
            return cell
        }
    }
    
    // 콜렉션뷰 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 111, height: 200)
    }
    
    
    
    
    //서치바 만들기
    func setSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.barTintColor = .systemBackground
        searchBar.layer.borderColor = UIColor.kGreen.cgColor // 테두리 색상 설정
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.cornerRadius = 20
        searchBar.backgroundImage = UIImage() //구분선 제거
        //돋보기 아이콘 넣기
        searchBar.setImage(UIImage(named: "icSearch"), for: UISearchBar.Icon.search, state: .normal)
        //삭제 아이콘 넣기
        searchBar.setImage(UIImage(named: "iCancel"), for: .clear, state: .normal)
        // 서치바의 프레임 설정
        searchBar.frame = CGRect(x: 25, y: 116, width: 342, height: 53)
        self.view.addSubview(searchBar)
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            //서치바 및 작성 전 안내 글씨색과 서치바 입력시 색 정하기
            textfield.backgroundColor = UIColor.systemBackground
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.kGray])
            textfield.textColor = UIColor.kBlack
            
            //왼쪽 돋보기 아이콘 넣기
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.kGreen
            }
            //오른쪽 x버튼 넣기
            if let rightView = textfield.rightView as? UIImageView {
                rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
                //이미지 틴트 정하기
                rightView.tintColor = UIColor.kBlack
            }
        }
    }
    
    
    //세그먼트와 화면전환 연결해주기 위해서 필수기능
    //뷰로만 보여지던 세그먼트에 실제기능 부여
//    func didTapSegment(_sender: UISegmentedControl) {}
//    func setSegment() {
//        segMovies = UISegmentedControl()
//        segMovies.insertSegment(withTitle: "현재상영작", at: 0, animated: true)
//        segMovies.insertSegment(withTitle: "상영예정작", at: 1, animated: true)
//    }
    
    
    
    
    private func autoLayout() {
        //현재상영작 콜렉션뷰 오토레이아웃
        firstCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250), // 원하는 Y 좌표로 설정
            firstCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 18),
            firstCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -18),
            firstCollectionView.heightAnchor.constraint(equalToConstant: 497) // 원하는 높이로 설정
        ])
        //상영예정작 콜렉션뷰 오토레이아웃
        secondCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250), // 원하는 Y 좌표로 설정
            secondCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 18),
            secondCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -18),
            secondCollectionView.heightAnchor.constraint(equalToConstant: 497) // 원하는 높이로 설정
        ])
        //서치창 콜렉션뷰 오토레이아웃
        thirdCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thirdCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250), // 원하는 Y 좌표로 설정
            thirdCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 18),
            thirdCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -18),
            thirdCollectionView.heightAnchor.constraint(equalToConstant: 497) // 원하는 높이로 설정
        ])
        //영화통합창 제목
        title1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title1.topAnchor.constraint(equalTo: view.topAnchor, constant: 68), // 원하는 Y 좌표로 설정
            title1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        //세그먼트컨트롤러 오토레이아웃
        segMovies.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segMovies.topAnchor.constraint(equalTo: view.topAnchor, constant: 188), // 원하는 Y 좌표로 설정
            segMovies.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            segMovies.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            segMovies.heightAnchor.constraint(equalToConstant: 42) // 원하는 높이로 설정
        ])
        
    }
    
    @objc private func changeUnderLinePosition() {
        let segmentIndex = CGFloat(segMovies.selectedSegmentIndex)
        let segmentWidth = segMovies.frame.width / CGFloat(segMovies.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.underLineView.snp.remakeConstraints { make in
                make.top.equalTo(self.segMovies.snp.bottom)
                make.leading.equalTo(self.segMovies).offset(leadingDistance)
                make.width.equalTo(segmentWidth)
                make.height.equalTo(3)
            }
            self.view.layoutIfNeeded() //연결안됨
        }
        fetchReleasedMovies()
    }
    
//    @objc func didTabSegment(_ sender: UISegmentedControl) {
////        guard !isAnimationWorking else { return }
////        isAnimationWorking.toggle()
//        let width = view.bounds.width
//        
//        guard segMovies.selectedSegmentIndex == 1 else {
//            updateVisibleView(from: firstCollectionView, to: secondCollectionView, moveX: width)
//            return
//        }
//        updateVisibleView(from: secondCollectionView, to: firstCollectionView, moveX: -width)
//    }
//    
//    func updateVisibleView(from: UIView, to: UIView, moveX: CGFloat) {
//        to.isHidden = false
//        segMovies.isUserInteractionEnabled = false
//        UIView.animate(
//            withDuration: 0.38,
//            delay: 0,
//            options: .curveEaseOut,
//            animations: {
//                to.transform = .identity
//                from.transform = .init(translationX: moveX, y: 0)
//            }, completion: { _ in
//                from.isHidden = true
//                self.segMovies.isUserInteractionEnabled = true
////                self.isAnimationWorking.toggle()
//            })
//    }
}
