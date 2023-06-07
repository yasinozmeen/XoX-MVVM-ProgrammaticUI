//
//  GameModel.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 5.06.2023.
//

struct GameModel: Codable {
    var lastUser: String
    var row: [Int : String]
    var whoWin: String? 
}
