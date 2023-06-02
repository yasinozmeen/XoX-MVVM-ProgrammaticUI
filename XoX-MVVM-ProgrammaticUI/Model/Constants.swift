//
//  Constants.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import Foundation

public enum ConstantsGame: String {
    case X = "X"
    case Y = "Y"
}

public enum ConstantsTabBar: String {
    case account = "account"
    case game    = "game"
}

public enum ConstantsLoginPage: String {
    case title    = "XoX"
    case username = "username"
    case password = "password"
    case button   = "sign in/up"
}

public enum ConstantsLoginPageAlert: String {
    case tfIsEmpty  = "please enter username and password :)"
    case newAccount = "do you want to create a new account ?"
}


public enum ConstantsGamePage: String {
    case turn = "turn : "
    case win  = "you win"
    case lose = "you lose"
    case tied = "you tied"
}
public enum ConstantsAccountPage: String {
    case username  = "username"
    case winGames  = "win games : "
    case loseGames = "lose games : "
    case totalGame = "total games : "
    case signOut   = "sign out"
}

