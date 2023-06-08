//
//  ErrorModel.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 8.06.2023.
//

import Foundation

enum AccountViewModelError: Error {
    case firebaseAuthSingOut
}

enum GameViewModelError: Error {
    case fetchIsOnlineUser
}
