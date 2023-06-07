//
//  AccountPageView.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import UIKit.UIView
import SnapKit

class AccountPageView: UIView {
//MARK: - Properties
    weak var delegate: AccountDelegate?
    typealias constant = ConstantsAccountPage
    
// MARK: - UI Elements
    private let title = CustomUILabel(text: constant.username.rawValue, fontSize: 48, weight: .black)
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle(constant.signOut.rawValue, for: .normal)
        button.tintColor = .label
        button.backgroundColor = .label
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(signOutDidTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Function
    func configure () {
        backgroundColor = .systemGray6
        setupUserName()
        setupSignOutButton()
    }
    
    //MARK: - Targets
    @objc func signOutDidTapped() {
        delegate?.signOutButtonTapped()
    }
}

// MARK: - Setup View With SnapKit
extension AccountPageView {
    func setupUserName() {
        addSubview(title)
        
        title.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    func setupSignOutButton() {
        addSubview(signOutButton)
        
        signOutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.width.equalTo(UIScreen.main.bounds.width * 0.5882352941)
        }
    }
    
}
