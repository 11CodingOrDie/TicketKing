//
//  LogInViewController.swift
//  TicketKing
//
//  Created by David Jang on 4/23/24.
//

import UIKit
import SnapKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let userIDTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 5.5
        textField.backgroundColor = .white
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        
        // 이미지 뷰 생성 및 설정
        let imageView = UIImageView(image: UIImage(systemName: "person"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.gray
        
        // 텍스트 필드의 leftView에 imageView 추가
        let symbolView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        imageView.frame = CGRect(x: 10, y: 14, width: 20, height: 20)
        symbolView.addSubview(imageView)
        
        textField.leftView = symbolView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "패스워드"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 5.5
        textField.backgroundColor = .white
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        
        // 이미지 뷰 생성 및 설정
        let imageView = UIImageView(image: UIImage(systemName: "lock"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.gray
        
        // 텍스트 필드의 leftView에 imageView 추가
        let symbolView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        imageView.frame = CGRect(x: 10, y: 14, width: 20, height: 20) // imageView 위치 조정
        symbolView.addSubview(imageView)
        
        textField.leftView = symbolView
        textField.leftViewMode = .always
        
        return textField
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
    
    private lazy var stayLoggedInView: UIStackView = {
        let checkBox = UIButton(type: .custom)
        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkBox.tintColor = .gray
        checkBox.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        
        let label = UILabel()
        label.text = "로그인 상태 유지"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [checkBox, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        userIDTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func toggleCheckbox(_ sender: UIButton) {
        sender.isSelected.toggle()
        UserDefaults.standard.set(sender.isSelected, forKey: "isUserLoggedIn")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)  // 모든 텍스트 필드의 편집을 종료하고 키보드를 숨깁니다.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("textFieldShouldReturn: \(textField.placeholder ?? "")")
        return true
    }
    
    private func textFieldDidBeginEditing(_ textField: UITextField) -> Bool {
        if textField == userIDTextField {
            (textField.leftView?.subviews.first as? UIImageView)?.tintColor = .black
            textField.layer.borderColor = UIColor(red: 0.914, green: 0.149, blue: 0.173, alpha: 1).cgColor
        } else if textField == passwordTextField {
            (textField.leftView?.subviews.first as? UIImageView)?.tintColor = .black
            textField.layer.borderColor = UIColor(red: 0.914, green: 0.149, blue: 0.173, alpha: 1).cgColor
        }
        print("textFieldShouldBeginEditing: \(textField.placeholder ?? "")")
            return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == userIDTextField {
            (textField.leftView?.subviews.first as? UIImageView)?.tintColor = .gray
            textField.layer.borderColor = UIColor.gray.cgColor
        } else if textField == passwordTextField {
            (textField.leftView?.subviews.first as? UIImageView)?.tintColor = .gray
            textField.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    private func setupLayout() {
        view.addSubview(logoImageView)
        view.addSubview(userIDTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(stayLoggedInView)
        view.addSubview(signUpButton)
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            make.width.equalTo(202)
            make.height.equalTo(43.3)
        }
        
        userIDTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(100)
            make.left.right.equalTo(view).inset(16)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userIDTextField.snp.bottom).offset(16)
            make.left.right.equalTo(view).inset(16)
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(32)
            make.left.right.equalTo(view).inset(16)
            make.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(19)
            make.right.equalTo(view).inset(16)
        }
        
        stayLoggedInView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(24)
            make.left.equalTo(view).inset(16)
        }
    }
    
    @objc private func loginButtonTapped() {
        guard let username = userIDTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Username or password cannot be empty")
            return
        }
        
        if let user = UserManager.shared.getUser(username: username), user.password == password {
            print("Login successful")
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            proceedToMainInterface()
        } else {
            print("Invalid username or password")
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        }
    }
    private func proceedToMainInterface() {
        let mainViewController = ViewController()
        mainViewController.modalPresentationStyle = .fullScreen
        present(mainViewController, animated: true)
    }

    @objc private func signUpButtonTapped() {
        let signUpVC = SignUpViewController()
        if let navigationController = self.navigationController {
            navigationController.pushViewController(signUpVC, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: signUpVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
    }
    
    private func validateLogin() -> Bool {
        guard let username = userIDTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Username or password cannot be empty")
            return false
        }
        
        if let userData = UserDefaults.standard.data(forKey: username),
           let savedUser = try? JSONDecoder().decode(User.self, from: userData),
           savedUser.password == password {
            return true
        } else {
            print("Invalid username or password")
            return false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userIDTextField.becomeFirstResponder()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
}

