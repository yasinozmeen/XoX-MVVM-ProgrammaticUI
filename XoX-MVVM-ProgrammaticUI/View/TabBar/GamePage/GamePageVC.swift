//
//  GamePageVC.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import UIKit.UIViewController
import SnapKit
import Firebase

final class GamePageVC: UIViewController {
    // MARK: - Properties
    let gamePageView     = GamePageView()
    let viewModel        = GameViewModel()
    let fireBaseDataBase = Firestore.firestore()
    var currentUser: String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        gamePageView.configure()
    }
    
    // MARK: - Functions
    private func configure () {
        view.addSubview(gamePageView)
        gamePageView.delegate = self
        setupLoginPageView()
        viewModel.getCurrentUser()
    }
    
    private func setupLoginPageView () {
        gamePageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension GamePageVC : GameProtocol {
    func buttonDidTapped(tag: Int) {
        viewModel.didPlay(tag: tag)
    }
}

