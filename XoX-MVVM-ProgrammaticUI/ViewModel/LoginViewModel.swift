//
//  ViewModel.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 3.06.2023.
//

import Foundation
import Firebase

// MARK: - Protocol
protocol LoginDelegate: AnyObject {
    func loginButtonTapped(mail:String, password:String)
    func createUserShowAlert(title: String?, message: String?, style: UIAlertController.Style, firstActionTitle: String?, secondActionTitle:String?, actionStyle: UIAlertAction.Style, handler: ((String?) -> Void)?)
    func showAlert(title: String?, message: String?, style: UIAlertController.Style, firstActionTitle: String?, actionStyle: UIAlertAction.Style)
    func goToTabBarController()
}

final class LoginViewModel {
    
// MARK: - Protperties
    weak var delegate: LoginDelegate?
    let fireBaseDataBase = Firestore.firestore()
    
// MARK: - Funcitons
    func signIn(mail:String,password:String) {
        Auth.auth().signIn(withEmail: mail, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if let _ = error{
                strongSelf.makeNoOneUserAlert(mail, password)
            }else{
                strongSelf.delegate?.goToTabBarController()
                strongSelf.saveUserOnline(mail: mail)
            }
        }
    }
    
    private func signUp(mail:String,password:String, handler: ((Error) -> Void)?) {
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
            if let error = error{
                handler?(error)
            }else{
                self.delegate?.goToTabBarController()
                self.saveUserOnline(mail: mail)
            }
        }
    }
    
    private func makeNoOneUserAlert(_ mail:String, _ password:String){
        self.delegate?.createUserShowAlert(title: ConstantsLoginPageAlert.title.rawValue, message: ConstantsLoginPageAlert.message.rawValue, style: .alert, firstActionTitle: ConstantsLoginPageAlert.create.rawValue, secondActionTitle:ConstantsLoginPageAlert.neverMind.rawValue, actionStyle: .cancel, handler: { title in
            if let str = title, str == ConstantsLoginPageAlert.create.rawValue {
                /// Create a New User
                self.signUp(mail: mail, password: password) { error in
                    self.signUpIsWrong(error: error)
                }
            }
        })
    }
    
    private func signUpIsWrong(error:Error) {
        self.delegate?.showAlert(title: ConstantsLoginPageAlert.error.rawValue, message: error.localizedDescription.lowercased(), style: .actionSheet, firstActionTitle: ConstantsLoginPageAlert.ok.rawValue, actionStyle: .cancel)
    }
    
    private func saveUserOnline(mail:String){
        fireBaseDataBase.collection("User").document(mail).setData([
            "is online":true
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
            }
        }
        // gamepage e gitmeden onceki son fonksiyon
    }
}


