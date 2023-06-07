//
//  Constants.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import Foundation
// MARK: - ConstantsGame
public enum ConstantsGame: String {
    case X = "X"
    case O = "O"
}

// MARK: - ConstantsTabBar
public enum ConstantsTabBar: String {
    case account      = "account"
    case game         = "game"
    case gameImage    = "gamecontroller"
    case accountImage = "person"
}

// MARK: - ConstantsLoginPage
public enum ConstantsLoginPage: String {
    case title    = "XoX"
    case username = "mail"
    case password = "password of 6 char"
    case button   = "sign in"
}

// MARK: - ConstantsLoginPageAlert
public enum ConstantsLoginPageAlert: String {
    case error     = "error"
    case ok        = "ok"
    case tfIsEmpty = "please enter username and password :)"
    case title     = "there is no such one but maybe the password is wrong"
    case message   = "do you want to create a new account ?"
    case create    = "create it"
    case neverMind = "never mind"
}

// MARK: - ConstantsGamePage
public enum ConstantsGamePage: String {
    case title = "user..."
    case win  = "you win"
    case lose = "you lose"
    case tied = "you tied"
    case ok   = "ok"
}

// MARK: - ConstantsAccountPage
public enum ConstantsAccountPage: String {
    case username  = "XoX"
    case winGames  = "win games : "
    case loseGames = "lose games : "
    case totalGame = "total games : "
    case signOut   = "sign out"
}
