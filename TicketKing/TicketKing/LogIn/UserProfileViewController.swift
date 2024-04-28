//
//  UserProfileViewController.swift
//  TicketKing
//
//  Created by David Jang on 4/29/24.
//

import Foundation
import UIKit
import SnapKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: User? // 현재 사용자 정보
    var favoriteMovies: [MovieDetails] = [] // 마이 영화 상세 정보 배열
    var bookedMovies: [MovieDetails] = [] // 예매 영화 상세 정보 배열
    private var buttons: [UIButton] = []
    private var segmentTitles = ["예매 내역", "마이 영화"]
    private let indicatorView = UIView()
    var tableView: UITableView!
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person")) // 기본 이미지 설정
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    private let changeImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("변경", for: .normal)
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        let iconImage = UIImage(systemName: "rectangle.portrait.and.arrow.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular))
        button.setImage(iconImage, for: .normal)
        button.tintColor = UIColor(named: "kRed")

        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private func setupNavigation() {
        self.title = "마이 페이지"
        
    }
    
    var nowPlayingMovies: [MovieModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        setupLayout()
        setupNavigation()
        setupTableView()  // 확실히 테이블 뷰를 여기서 설정합니다.
        fetchNowPlayingMovies()
        
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    @objc func logoutTapped() {
        // 로그인 상태 정보 제거
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.removeObject(forKey: "currentUserID")
        UserDefaults.standard.removeObject(forKey: "profileImageFilename")

        // 로그인 뷰 컨트롤러로 전환
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            let loginViewController = LogInViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        } else {
            print("Unable to access the SceneDelegate window")
        }
    }
    
    // 영화 데이터 가져오기
    private func fetchNowPlayingMovies(language: String = "ko-KR", page: Int = 1) {
        Task {
            await GenreManager.shared.loadGenresAsync()
            do {
                let nowPlayingMovies = try await MovieManager.shared.fetchNowPlayingMovies(page: page, language: language)
                self.nowPlayingMovies = nowPlayingMovies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching popular movies: \(error)")
            }
        }
    }
    
    // TableView 설정
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieInfoTableViewCell.self, forCellReuseIdentifier: "MovieInfoCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.frame.height / 2)  // 화면의 절반 크기
        }
    }
    
    // TableView DataSource 및 Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nowPlayingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoCell", for: indexPath) as? MovieInfoTableViewCell else {
            fatalError("Unable to dequeue MovieInfoTableViewCell")
        }
        cell.configure(with: nowPlayingMovies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100  // 테이블 뷰 셀의 높이 설정
    }
    
    private func setupLayout() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(changeImageButton)
        view.addSubview(logoutButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.width.height.equalTo(66)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(32)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nameLabel.snp.leading)
        }
        
        changeImageButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.centerX.equalTo(profileImageView.snp.centerX)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(6)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
        }
        
        setupSegmentControl()
    }
    
    
    
    
    
    
    
    
    private func setupSegmentControl() {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(changeImageButton.snp.top).offset(32)
            make.centerX.equalTo(view)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(32)
        }
        
        segmentTitles.forEach { title in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            button.addTarget(self, action: #selector(segmentButtonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        buttons.first?.isSelected = true
        setupIndicatorView()
    }
    
    private func setupIndicatorView() {
        guard let firstButton = buttons.first else { return }
        view.addSubview(indicatorView)
        indicatorView.backgroundColor = .red
        
        indicatorView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(firstButton.snp.bottom)
            make.width.equalTo(firstButton.snp.width)
            make.centerX.equalTo(firstButton.snp.centerX)
        }
    }
    
    @objc private func segmentButtonTapped(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = (button == sender)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.snp.remakeConstraints { make in
                make.height.equalTo(2)
                make.top.equalTo(sender.snp.bottom)
                make.width.equalTo(sender.snp.width)
                make.centerX.equalTo(sender.snp.centerX)
            }
            self.view.layoutIfNeeded()
        }
    }
}
