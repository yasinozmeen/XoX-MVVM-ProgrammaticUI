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
//    var gameProtocol:GameProtocol?
    
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
        viewModel.delegate = self
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
    func buttonTitleChange(title: String, tag: Int) {
        gamePageView.buttons[tag - 1]!.setTitle(title, for: .normal)
    }
    
    func changeTurnLabelP(turnIs:String) {
        gamePageView.isTurn.text = turnIs
    }
    
    func buttonDidTappedP(tag:Int) {
        viewModel.buttonDidTapped(tag: tag)
    }
    
}
    
