//
//  ViewModel.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 3.06.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

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
    
    /// The function we are trying to login to. If the login process is successful, the "goToTabBarController" and "saveUserOnline" functions are executed. If the login process is unsuccessful, the "makeNoOneUserAlert" function is executed.
    /// - Parameters:
    ///   - mail: User's e-mail address
    ///   - password: User's password
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
    
    /// The function where we register a new user in FirebaseAuth. If the registration process is successful, the functions goToTabBarController and saveUserOnline are called. If the registration process fails, we send the error information using the handler function.
    /// - Parameters:
    ///   - mail: User's e-mail address
    ///   - password: User's password
    ///   - handler: When encountering an error, we send the error using the handler function.
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
    
    /// The function that we call when attempting to log in with a user who is not registered in FirebaseAuth or when entering incorrect credentials.
    /// - Parameters:
    ///   - mail: The email address that is being used for the login attempt.
    ///   - password: The password that is being used for the login attempt.
    private func makeNoOneUserAlert(_ mail:String, _ password:String){
        self.delegate?.createUserShowAlert(
            title: ConstantsLoginPageAlert.title.rawValue,
            message: ConstantsLoginPageAlert.message.rawValue,
            style: .alert,
            firstActionTitle: ConstantsLoginPageAlert.create.rawValue,
            secondActionTitle:ConstantsLoginPageAlert.neverMind.rawValue,
            actionStyle: .cancel,
            handler: { title in
            if let str = title, str == ConstantsLoginPageAlert.create.rawValue {
                /// Create a New User
                self.signUp(mail: mail, password: password) { error in
                    self.signUpIsWrong(error: error)
                }
            }
        })
    }
    
    /// The function that we call when there is an issue during the registration process.
    /// - Parameter error: The parameter where we pass the error, received as an instance of the `Error` type, when encountering an issue.
    private func signUpIsWrong(error:Error) {
        self.delegate?.showAlert(title: ConstantsLoginPageAlert.error.rawValue, message: error.localizedDescription.lowercased(), style: .actionSheet, firstActionTitle: ConstantsLoginPageAlert.ok.rawValue, actionStyle: .cancel)
    }
    
    ///The function used to save the user online in the Firebase Firestore system.
    /// - Parameter mail: The email address that is being used for the login attempt.
    private func saveUserOnline(mail:String){
        fireBaseDataBase.collection("User").document(mail).setData([
            "is online":true
        ]) { err in
            print(err?.localizedDescription as Any)
        }
    }
}


