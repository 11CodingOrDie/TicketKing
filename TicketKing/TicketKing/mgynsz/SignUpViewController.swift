//
//  SignUpViewController.swift
//  TicketKing
//
//  Created by David Jang on 4/23/24.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let userIDTextField: LabeledTextField = {
        let textField = LabeledTextField(title: "아이디", placeholder: "example", instructionText: "아이디를 입력해주세요.(3글자 이상)")
        return textField
    }()
    
    private let passwordTextField: LabeledTextField = {
        let textField = LabeledTextField(title: "비밀번호", placeholder: "비밀번호", instructionText: "영문, 대·소문자, 숫자, 특수문자(8~16 자)")
        return textField
    }()
    
    private let passwordConfirmTextField: LabeledTextField = {
        let textField = LabeledTextField(title: "비밀번호 확인", placeholder: "비밀번호 확인", instructionText: "비밀번호를 올바르게 입력하세요.")
        return textField
    }()
    
    private let nameTextField: LabeledTextField = {
        let textField = LabeledTextField(title: "이름", placeholder: "11조 화이팅!", instructionText: "이름을 입력해주세요.")
        return textField
    }()
    
    private let emailTextField: LabeledTextField = {
        let textField = LabeledTextField(title: "이메일", placeholder: "example@gmail.com", instructionText: "이메일 형식에 맞게 입력바랍니다.")
        return textField
    }()
    
    private let birthdatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    
    private let genderPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor(red: 0.102, green: 0.604, blue: 0.545, alpha: 1).cgColor
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5.5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        return button
    }()
    
    let genders = ["남성", "여성", "비밀"]
    
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(signUpButton)
        
        setupScrollView()
        setupSignUpButton()
        setupLayout()
        setupNavigation()
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    private func setupNavigation() {
        self.title = "회원 가입"
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(signUpButton.snp.top)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
            make.height.equalTo(view).priority(.low)
        }
    }
    
    private func setupSignUpButton() {
        signUpButton.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(50)
        }
    }
    
    private func setupLayout() {

        contentView.addSubview(userIDTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(passwordConfirmTextField)
        contentView.addSubview(nameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(birthdatePicker)
        contentView.addSubview(genderPicker)
        
        userIDTextField.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(40)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(userIDTextField.snp.bottom).offset(48)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(50)
        }
        
        passwordConfirmTextField.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(passwordTextField.snp.bottom).offset(48)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(50)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(48)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(nameTextField.snp.bottom).offset(48)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(50)
        }
        
        birthdatePicker.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(emailTextField.snp.bottom).offset(48)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(50)
        }
        
        genderPicker.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(birthdatePicker.snp.bottom).offset(48)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(50)
        }
    }
    
    // 이메일 유효성 검사 함수
    private func isValidEmail(_ email: String) -> Bool {
        // 정규표현식
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    @objc private func signUpButtonTapped() {
        guard let userID = userIDTextField.text, !userID.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let passwordConfirm = passwordConfirmTextField.text, !passwordConfirm.isEmpty,
              let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty else {
            print("All fields are required")
            return
        }
        
        // 비밀번호 유효성 검사
        if !isValidPassword(password) {
            passwordTextField.setInstructionText("올바르지 않은 비밀번호 형식입니다")
            passwordTextField.instructionLabel.isHidden = false
            return
        }
        
        // 비밀번호 일치 검사
        if password != passwordConfirm {
            passwordConfirmTextField.setInstructionText("비밀번호가 일치하지 않습니다")
            passwordConfirmTextField.instructionLabel.isHidden = false
            return
        }
        
        // 이메일 유효성 검사
        if !isValidEmail(email) {
            emailTextField.setInstructionText("이메일 형식에 맞게 입력바랍니다")
            emailTextField.instructionLabel.isHidden = false
        } else {
            emailTextField.setInstructionText("")
        }
        
        // 이메일 유효성 검사 후 유저 생성
        let newUser = User(userID: userID, password: password, email: email, name: name)
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
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,16}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // 키보드가 나타날 때 호출되는 메서드
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // 키보드의 높이를 구합니다.
        let keyboardHeight = keyboardFrame.height
        
        // 스크롤뷰의 콘텐츠를 키보드 높이만큼 조정합니다.
        scrollView.contentInset.bottom = keyboardHeight
    }

    // 키보드가 사라질 때 호출되는 메서드
    @objc private func keyboardWillHide(notification: Notification) {
        // 스크롤뷰의 콘텐츠 인셋을 초기화합니다.
        scrollView.contentInset = .zero
    }

    // 뷰가 나타날 때 키보드 관련 알림을 등록합니다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 뷰가 사라질 때 키보드 관련 알림을 제거합니다.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        view.endEditing(true)
    }
}
