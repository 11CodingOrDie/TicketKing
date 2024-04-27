//
//  ProfileViewController.swift
//  TicketKing
//
//  Created by David Jang on 4/25/24.
//

import Foundation
import UIKit
import SnapKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var user: User? // 현재 사용자 정보
    var favoriteMovies: [MovieDetails] = [] // 마이 영화 상세 정보 배열
    var bookedMovies: [MovieDetails] = [] // 예매 영화 상세 정보 배열
    private var buttons: [UIButton] = []
    private var segmentTitles = ["예매 내역", "마이 영화"]
    private let indicatorView = UIView()
    var tableView: UITableView!
    var nowPlayingMovies: [MovieModel] = [] // 임시값
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person")) // 기본 이미지 설정
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 36
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
        return label
    }()
    
    private let changeImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("변경", for: .normal)
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor(red: 0.102, green: 0.604, blue: 0.545, alpha: 1).cgColor
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5.5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return button
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.opacity = 0.1
        return imageView
    }()
    
    private var isLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        setupLayout()

        loginButton.addTarget(self, action: #selector(navigateToLogin), for: .touchUpInside)
        
        // NotificationCenter에 로그인 상태 변경 알림 등록
        NotificationCenter.default.addObserver(self, selector: #selector(updateUIBasedOnLoginStatus), name: .didChangeLoginStatus, object: nil)
        
        setupNotifications()
        updateUIBasedOnLoginStatus()
        fetchNowPlayingMovies()
        changeImageButton.addTarget(self, action: #selector(changeImageTapped), for: .touchUpInside)
//        tableView.register(ProfileViewTableViewCell.self, forCellReuseIdentifier: "ProfileViewTableViewCell")

//        setupLayout()
//        setupNotifications()
//        updateUIBasedOnLoginStatus()
    }
    func loginUser(withID userID: String, password: String) {
        // 예시: 사용자 검증 로직
        if userID == "expectedUserID" && password == "expectedPassword" {
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.set(userID, forKey: "currentUserID")
            NotificationCenter.default.post(name: .didChangeLoginStatus, object: nil)
        } else {
            print("Login failed: Invalid credentials")
        }
    }

    func logoutUser() {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.removeObject(forKey: "currentUserID")
        NotificationCenter.default.post(name: .didChangeLoginStatus, object: nil)
    }
    
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUIBasedOnLoginStatus), name: .didChangeLoginStatus, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func updateUIBasedOnLoginStatus() {
        DispatchQueue.main.async {
            if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
                // 로그인 상태일 때 UI 업데이트
                self.loginButton.isHidden = true
                self.profileImageView.isHidden = false
                self.nameLabel.isHidden = false
                self.emailLabel.isHidden = false
                self.changeImageButton.isHidden = false
                self.logoImageView.isHidden = true
                self.loadUserProfile()
            } else {
                // 로그아웃 상태일 때 UI 업데이트
                self.loginButton.isHidden = false
                self.profileImageView.isHidden = true
                self.nameLabel.isHidden = true
                self.emailLabel.isHidden = true
                self.changeImageButton.isHidden = true
                self.logoImageView.isHidden = false
                self.profileImageView.image = UIImage(named: "defaultProfile")
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(changeImageButton)
        view.addSubview(loginButton)
        view.addSubview(logoImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.width.height.equalTo(70)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(32)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(nameLabel.snp.leading)
        }
        
        changeImageButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.centerX.equalTo(profileImageView.snp.centerX)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.centerX.equalToSuperview()
            //            make.centerY.equalTo(view.snp.centerY)
            make.left.right.equalTo(view).inset(16)
            make.height.equalTo(50)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(view.snp.top).offset(550)
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
    
    @objc func navigateToLogin() {
        let loginVC = LogInViewController()
        loginVC.modalPresentationStyle = .formSheet
        loginVC.modalTransitionStyle = .coverVertical
        self.present(loginVC, animated: true, completion: nil)
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
    
//    // 임시 데이터 로드 함수
//    private func loadTemporaryData() {
//        nameLabel.text = "mgynsz"
//        emailLabel.text = "mgynsz@gmail.com"
//        profileImageView.image = UIImage(systemName: "person.crop.circle") // 시스템 아이콘 사용
//    }
//    
    @objc private func changeImageTapped() {
        presentImagePicker()
    }
    
    private func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = editedImage
            saveImage(image: editedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func saveImage(image: UIImage) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let fileURL = getDocumentsDirectory().appendingPathComponent("profileImage.jpg")
            do {
                try data.write(to: fileURL)
                print("Image saved: \(fileURL)")
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }
    
    private func loadImage() {
        if let imagePath = UserDefaults.standard.string(forKey: "profileImagePath"),
           let imageData = FileManager.default.contents(atPath: imagePath) {
            let image = UIImage(data: imageData)
            profileImageView.image = image
        } else {
            print("Failed to load image from path")
        }
    }

    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func loadUserProfile() {
        guard let userID = UserDefaults.standard.string(forKey: "currentUserID") else {
            print("No user ID found in UserDefaults")
            return
        }
        
        if let user = UserManager.shared.loadUser(userID: userID) {
            // 로드 성공시 UI 업데이트
            DispatchQueue.main.async {
                self.nameLabel.text = user.name
                self.emailLabel.text = user.email
                if let imageData = user.profileImageData {
                    self.profileImageView.image = UIImage(data: imageData)
                }
            }
        } else {
            print("Failed to load user profile")
        }
    }

    
    func loadUserMovies() {
        guard let user = user else { return }
        Task {
            do {
                favoriteMovies = try await fetchMoviesDetails(ids: user.favoriteMovies)
                bookedMovies = try await fetchMoviesDetails(ids: user.bookedMovies)
                // UI 업데이트 로직
            } catch {
                print("Error fetching movies: \(error)")
            }
        }
    }
    
    private func fetchMoviesDetails(ids: [String]) async throws -> [MovieDetails] {
        var details: [MovieDetails] = []
        for id in ids {
            if let movieId = Int(id) {
                let detail = try await MovieManager.shared.fetchMovieDetails(for: movieId)
                details.append(detail)
            }
        }
        return details
    }
    
    // TableView 설정
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProfileViewTableViewCell.self, forCellReuseIdentifier: "ProfileViewTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(indicatorView.snp.bottom).offset(20)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // 사용자 영화 정보가 아닌 임시로 영화 데이터 가져오기
    private func fetchNowPlayingMovies(language: String = "ko-KR", page: Int = 1) {
        Task {
            await GenreManager.shared.loadGenresAsync()
            do {
                let nowPlayingMovies = try await MovieManager.shared.fetchNowPlayingMovies(page: page, language: language)
                self.nowPlayingMovies = nowPlayingMovies
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if let tableView = self.tableView {
                        tableView.reloadData()
                    } else {
                        print("TableView is not initialized")
                    }
                }
            } catch {
                print("Error fetching popular movies: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nowPlayingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewTableViewCell", for: indexPath)
        cell.textLabel?.text = nowPlayingMovies[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100  // 테이블 뷰 셀의 높이 설정
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = nowPlayingMovies[indexPath.row]
            let alert = UIAlertController(title: "Delete Movie", message: "Are you sure you want to remove '\(movie.title)' from your list?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                self.nowPlayingMovies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension Notification.Name {
    static let didChangeLoginStatus = Notification.Name("didChangeLoginStatus")
}
