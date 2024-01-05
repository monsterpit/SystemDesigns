//
//  Player.swift
//  TicTacToe
//
//  Created by Vikas Salian on 05/01/24.
//

import Foundation

enum GameState{
    case invalidMove
    case matchDraw
    case matchEnded
    case matchWon(player: Player)
}

class Player{
    var name: String
    var sign: String
    
    init(name: String, sing: String) {
        self.name = name
        self.sign = sing
    }
}
