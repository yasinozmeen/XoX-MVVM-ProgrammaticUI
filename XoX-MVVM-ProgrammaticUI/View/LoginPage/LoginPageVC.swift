//
//  ViewController.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import UIKit.UIViewController
import SnapKit

final class LoginPageVC: UIViewController {
// MARK: - Properties
    let loginPageView = LoginPageView()
    let viewModel = ViewModel()
    
// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loginPageView.configure()
    }
    
// MARK: - Functions
    private func configure () {
        view.addSubview(loginPageView)
        
        /// Delegation Equalization
        loginPageView.delegate = self
        viewModel.delegate = self
        
        setupLoginPageView()
        navigationControllerBackButtonIsHidden(true)
    }
    
    private func setupLoginPageView () {
        loginPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func navigationControllerBackButtonIsHidden(_ bool: Bool){
        navigationController?.setNavigationBarHidden(bool, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - LoginPageViewDelegate
extension LoginPageVC: LoginPageViewDelegate {
    func showAlert(title: String?, message: String?, style: UIAlertController.Style, firstActionTitle: String?, secondActionTitle: String?, actionStyle: UIAlertAction.Style, handler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let firstAlertAction = UIAlertAction(title: firstActionTitle, style: actionStyle) { _ in
            print("first")
        }
        let secondAlertAction = UIAlertAction(title: secondActionTitle, style: .destructive ) { _ in
            print("second")
        }
        alertController.addAction(firstAlertAction)
        alertController.addAction(secondAlertAction)
        present(alertController, animated: true)
    }
    
    func showAlert(title: String?, message: String?, style: UIAlertController.Style, actionTitle: String?, actionStyle: UIAlertAction.Style, handler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let alertAction = UIAlertAction(title: actionTitle, style: actionStyle) { _ in
            handler?()
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true)
        
    }
    
    
    func showAlert(title: String?, message: String?, style: UIAlertController.Style, actionTitle: String?, actionStyle: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) {
        
    }
    
    
    func loginButtonTapped(mail:String, password:String) {
        viewModel.signIn(mail: mail, password: password)
    }
    
    
}
