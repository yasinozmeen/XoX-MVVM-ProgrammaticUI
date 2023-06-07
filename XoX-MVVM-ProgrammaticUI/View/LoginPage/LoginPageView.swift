//
//  LoginPageView.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.

// iphone 14 resulation is 844x320

import UIKit.UIView
import SnapKit

class LoginPageView : UIView {
    
    // MARK: - Properties
    weak var delegate: LoginDelegate?
    typealias constant = ConstantsLoginPage
    
    // MARK: - UI Elements
    private let XoXTitleLabel = CustomUILabel(text: constant.title.rawValue, fontSize: 48, weight: .bold)
    
    private let usernameTF = CustomUITextfield(
        placeholder: constant.username.rawValue,
        keyboardType: .emailAddress,
        textType: .emailAddress,
        AutocapitalizationType: .none,
        isSecure: false)
    
    private let passwordTF = CustomUITextfield(
        placeholder: constant.password.rawValue,
        keyboardType: .default,
        textType: .password,
        AutocapitalizationType: .none,
        isSecure: true)

    private let signButton: UIButton = {
        let button = UIButton()
        button.setTitle(constant.button.rawValue, for: .normal)
        button.tintColor = .label
        button.backgroundColor = .blue
        button.layer.cornerRadius = UIScreen.main.bounds.height * 0.0059241706
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(didTappedSignButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Function
    func configure () {
        backgroundColor = .systemGray6
        setupXoXTitleLabel()
        setupUsernameTF()
        setupPasswordTF()
        setupSignButton()
    }
    
    // MARK: - Targets
    @objc func didTappedSignButton() {
        delegate?.loginButtonTapped(mail: usernameTF.text!, password: passwordTF.text!)
    }
    
}


// MARK: - Snapkit View SetUp Part
extension LoginPageView {
    
    private func setupXoXTitleLabel() {
        self.addSubview(XoXTitleLabel)
        
        XoXTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.1184834123)
            make.centerX.equalToSuperview()
        }
    }
    private func setupUsernameTF() {
        self.addSubview(usernameTF)
        
        usernameTF.snp.makeConstraints { make in
            make.top.equalTo(XoXTitleLabel.snp.bottom).offset(UIScreen.main.bounds.height *  0.0236966825)
            make.centerX.equalTo(XoXTitleLabel)
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width * 0.8)
            make.width.greaterThanOrEqualTo(UIScreen.main.bounds.width * 0.5)
        }
        
    }
    private func setupPasswordTF() {
        self.addSubview(passwordTF)
        
        passwordTF.snp.makeConstraints { make in
            make.top.equalTo(usernameTF.snp.bottom).offset(UIScreen.main.bounds.height *  0.0115)
            make.leading.equalTo(usernameTF)
            make.trailing.equalTo(usernameTF)
            make.height.equalTo(usernameTF)
        }
    }
    private func setupSignButton() {
        self.addSubview(signButton)
        
        signButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTF.snp.bottom).offset(UIScreen.main.bounds.height *  0.0236966825)
            make.leading.equalTo(passwordTF)
            make.trailing.equalTo(passwordTF)
            make.height.equalTo(passwordTF)
        }
    }
    
    
}
