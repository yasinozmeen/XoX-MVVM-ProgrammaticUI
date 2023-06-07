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
// sanırım burası gereksiz bir katman direk viewmodele bağlanabilirdik dimi abi ?
extension GamePageVC : GameProtocol {
    
    func showAlert(title:String,
                   style: UIAlertController.Style,
                   actiontitle:String,
                   actionStyle:UIAlertAction.Style) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: style)
        let alertAction = UIAlertAction(title: actiontitle, style: actionStyle) { action in
            
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    func buttonTitleChange(title: String, tag: Int) {
        gamePageView.buttons[tag]?.setTitle(title, for: .normal)
    }
    
    func changeTurnLabelP(turnIs:String) {
        gamePageView.isTurn.text = turnIs
    }
    
    func buttonDidTappedP(tag:Int) {
        viewModel.buttonDidTapped(tag: tag)
    }
}
    
