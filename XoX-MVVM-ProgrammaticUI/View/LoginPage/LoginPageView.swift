//
//  LoginPageView.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.

// iphone 14 resulation is 844x320

import UIKit
import SnapKit

class LoginPageView : UIView {
    
    
    // MARK: - UI Elements
    
    private let XoXTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "XoX"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        return label
    }()
    private let usernameTF: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "username"
        return tf
    }()
    private let passwordTF: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "password"
        return tf
    }()
    private let signButton: UIButton = {
        let button = UIButton()
        button.setTitle("sing in/up", for: .normal)
        button.tintColor = .label
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
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
    
    // MARK: - Actions
    
    @objc func didTappedSignButton() {
        let tabBarController = TabBarController()
        let navigationController = UINavigationController(rootViewController: tabBarController)
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
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
            make.top.equalTo(XoXTitleLabel.snp.bottom).offset(20)
            make.centerX.equalTo(XoXTitleLabel)
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width * 0.8)
            make.width.greaterThanOrEqualTo(UIScreen.main.bounds.width * 0.5)
        }
        
    }
    private func setupPasswordTF() {
        self.addSubview(passwordTF)
        
        passwordTF.snp.makeConstraints { make in
            make.top.equalTo(usernameTF.snp.bottom).offset(10)
            make.leading.equalTo(usernameTF)
            make.trailing.equalTo(usernameTF)
            make.height.equalTo(usernameTF)
        }
    }
    private func setupSignButton() {
        self.addSubview(signButton)
        
        signButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTF.snp.bottom).offset(20)
            make.leading.equalTo(passwordTF)
            make.trailing.equalTo(passwordTF)
            make.height.equalTo(passwordTF)
        }
    }
}
