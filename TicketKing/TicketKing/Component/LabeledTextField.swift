//
//  LabeledTextField.swift
//  TicketKing
//
//  Created by David Jang on 4/23/24.
//

import UIKit
import SnapKit

class LabeledTextField: UIView, UITextFieldDelegate {
    
    private let label = UILabel()
    private let textField = UITextField()
    var instructionLabel = UILabel()

    init(title: String, placeholder: String, instructionText: String) {
        super.init(frame: .zero)
        setupViews(title: title, placeholder: placeholder, instructionText: instructionText)
        textField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var text: String? {
        return textField.text
    }

    func setInstructionText(_ text: String) {
        instructionLabel.text = text
    }

    private func setupViews(title: String, placeholder: String, instructionText: String) {
        label.text = title
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black

        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.isEnabled = true
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.textColor = .lightGray
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 5.5
        textField.isSecureTextEntry = title.contains("비밀번호")
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.autocapitalizationType = .none
        textField.keyboardType = title == "이메일" ? .emailAddress : .default
        
        instructionLabel.text = instructionText
        instructionLabel.font = UIFont.systemFont(ofSize: 13)
        instructionLabel.textColor = UIColor(red: 0.957, green: 0.584, blue: 0.592, alpha: 1)

        addSubview(label)
        addSubview(textField)
        addSubview(instructionLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)  // Ensure it doesn't overlap with instructionLabel
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(label.snp.centerY)  // Align vertically with the label
            make.leading.equalTo(label.snp.trailing).offset(16)  // 16 points away from label's trailing
            make.trailing.lessThanOrEqualToSuperview().offset(-32)  // Ensure it doesn't go off the edge
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        instructionLabel.isHidden = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            instructionLabel.isHidden = false
        } else {
            instructionLabel.isHidden = true
        }
    }
}

