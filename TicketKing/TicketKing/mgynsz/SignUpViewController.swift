//
//  SignUpViewController.swift
//  TicketKing
//
//  Created by David Jang on 4/23/24.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        usernameTextField.isUserInteractionEnabled = true

        
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, passwordTextField, emailTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50)
        ])
    }
    
    @objc private func signUpButtonTapped() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let email = emailTextField.text, !email.isEmpty else {
            print("All fields are required")
            return
        }
        
        let newUser = User(username: username, password: password, email: email)
        UserManager.shared.saveUser(user: newUser)
        print("User registered successfully")
        
        // 회원가입 후 메인 화면으로 전환
        if let navigationController = navigationController {
            let mainViewController = ViewController()
            navigationController.pushViewController(mainViewController, animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)  // 모든 텍스트 입력을 종료하고 키보드를 숨깁니다.
    }

}
