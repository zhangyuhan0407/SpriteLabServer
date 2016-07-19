//
//  BTMessage.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/1/16.
//
//


import Foundation
//import SwiftyJSON


let UserID = "WebSocketServer"



public struct BTMessage: CustomStringConvertible {
    
    public var userid: String = UserID
    
    public var command: BTCommand
    
    public var params: String
    
    
    public init?(from string: String) {
        
        
//        let json = JSON.parse(string: s).dictionaryValue
//
//
//        guard let id = json["userid"]?.string else {
//            Logger.error("\(json)\n NO userid")
//            return nil
//        }
//
//        guard let battleFieldID = json["battle_field_id"]?.string else {
//            Logger.error("\(json)\n NO Battle Field ID")
//            return nil
//        }
//
//
//        guard let command = json["command"]?.string else {
//            Logger.error("\(json)\n NO Command")
//            return nil
//        }
//
//
//        self.battleFieldID = battleFieldID
//        self.userID = id
//        self.command = command
//        self.params = json["params"]?.dictionaryObject
        
        
        let strings = string.components(separatedBy: "_")
        
        if strings.count < 3 {
            print(string)
            return nil
        }
        
        
        self.userid = strings[0]
        self.command = BTCommand.decode(string: strings[1])
        self.params = strings[2]
        
        
    }
    
    
    public init(command: BTCommand, params: String = "") {
        self.command = command
        self.params = params
    }
    
    
    public var description: String {
        return "\(userid)_\(command)_\(params)"
    }
    
    
    
}





