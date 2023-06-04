//
//  AccountPageView.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import UIKit
import SnapKit
import Firebase

class AccountPageView: UIView {
//MARK: - Properties
    weak var delegate: AccountDelegate?
    typealias constant = ConstantsAccountPage
    
// MARK: - UI Elements
    private let username    = CustomUILabel(text: constant.username.rawValue, fontSize: 48, weight: .black)
    private let winGame     = CustomUILabel(text: constant.winGames.rawValue, fontSize: 30, weight: .light)
    private let loseGame    = CustomUILabel(text: constant.loseGames.rawValue, fontSize: 30, weight: .light)
    private let totalGame   = CustomUILabel(text: constant.totalGame.rawValue, fontSize: 30, weight: .light)
    
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
        setupWinGame()
        setupLoseGame()
        setupTotalGame()
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
        addSubview(username)
        
        username.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.1184834123)
        }
    }
    
    func setupWinGame() {
        addSubview(winGame)
        
        winGame.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(username.snp_bottomMargin).offset(UIScreen.main.bounds.height * 0.1470588235)
        }
    }

    func setupLoseGame() {
        addSubview(loseGame)
        
        loseGame.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(winGame.snp_bottomMargin).offset(UIScreen.main.bounds.height * 0.0588235294)
        }
    }

    func setupTotalGame() {
        addSubview(totalGame)
        
        totalGame.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loseGame.snp_bottomMargin).offset(UIScreen.main.bounds.height * 0.0588235294)
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
