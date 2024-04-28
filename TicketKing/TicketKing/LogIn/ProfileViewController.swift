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
        // 'arrow.right.square'는 예시로 사용된 SF Symbols의 아이콘입니다. 적절한 아이콘으로 교체해야 합니다.
        let iconImage = UIImage(systemName: "rectangle.portrait.and.arrow.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular))
        button.setImage(iconImage, for: .normal)
        button.tintColor = UIColor(named: "kRed")  // 아이콘 색상 설정

        button.backgroundColor = .white  // 배경색 설정
        button.layer.cornerRadius = 10   // 코너 레디우스 설정
        button.clipsToBounds = true
        
//        // 버튼의 크기 설정
//        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        setupLayout()
        setupNavigation()
        
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        loadUserProfile()
        if let userID = UserDefaults.standard.string(forKey: "currentUserID") {
            loadImage(userID: userID)
        } else {
            print("No user ID found in UserDefaults")
        }
        changeImageButton.addTarget(self, action: #selector(changeImageTapped), for: .touchUpInside)
        
        
    }
    
    private func setupNavigation() {
        self.title = "마이 페이지"
        
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
            if let userID = UserDefaults.standard.string(forKey: "currentUserID") {
                saveImage(image: editedImage, userID: userID) // 사용자 ID를 포함하여 이미지 저장
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Documents 디렉토리의 URL을 반환하는 함수
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadImage(userID: String) {
        let filenameKey = "profileImageFilename_\(userID)"
        if let filename = UserDefaults.standard.string(forKey: filenameKey) {
            let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
            if let imageData = FileManager.default.contents(atPath: fileURL.path) {
                let image = UIImage(data: imageData)
                profileImageView.image = image
                print("Loaded image from: \(fileURL)")
            } else {
                // 이미지 파일이 없거나 읽을 수 없을 때 기본 이미지 설정
                profileImageView.image = UIImage(systemName: "person")
                print("Failed to load image from \(fileURL)")
            }
        } else {
            // UserDefaults에 파일 이름이 저장되어 있지 않을 때
            profileImageView.image = UIImage(systemName: "person")
            print("No image found for user \(userID)")
        }
    }
    
    func saveImage(image: UIImage, userID: String) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let filename = "profileImage_\(userID).jpg" // 사용자 ID를 포함한 파일명
            let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
            do {
                try data.write(to: fileURL)
                UserDefaults.standard.set(filename, forKey: "profileImageFilename_\(userID)")
                profileImageView.image = UIImage(data: data)
                print("Image saved at: \(fileURL)")
                
                NotificationCenter.default.post(name: .profileImageUpdated, object: nil)
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }
    
    @objc private func loadUserProfile() {
        guard let userID = UserDefaults.standard.string(forKey: "currentUserID") else {
            print("No user ID found in UserDefaults")
            return
        }
        
        if let user = UserManager.shared.loadUser(userID: userID) {
            nameLabel.text = user.name
            emailLabel.text = user.email
        } else {
            print("Failed to load user profile")
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

