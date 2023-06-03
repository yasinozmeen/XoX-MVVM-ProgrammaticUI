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
    case Y = "Y"
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
    case username = "email"
    case password = "password"
    case button   = "sign in"
}

// MARK: - ConstantsLoginPageAlert
public enum ConstantsLoginPageAlert: String {
    case tfIsEmpty           = "please enter username and password :)"
    case noOne               = "there is no one"
    case doYouWantnewAccount = "do you want to create a new account ?"
    case create              = "create it"
    case neverMind           = "never mind"
}

// MARK: - ConstantsGamePage
public enum ConstantsGamePage: String {
    case turn = "turn : "
    case win  = "you win"
    case lose = "you lose"
    case tied = "you tied"
}

// MARK: - ConstantsAccountPage
public enum ConstantsAccountPage: String {
    case username  = "username"
    case winGames  = "win games : "
    case loseGames = "lose games : "
    case totalGame = "total games : "
    case signOut   = "sign out"
}

