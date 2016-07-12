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

struct BTMessage: CustomStringConvertible {
    
    var userID: String = UserID
    
    var command: BTCommand
    
//    var params: Dictionary<String, AnyObject>?
    
    var params: String?
    
    
    init?(from string: String) {
        
        
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
        self.userID = strings[0]
        self.command = BTCommand.decode(string: strings[1])
//        self.params = strings[2]
        
        
        if strings.count > 2 {
//            let param = strings[2]
//            
//            let pairs = param.components(separatedBy: "#")
//            for pair in pairs {
//                
//            }
            
            self.params = strings[2]
            
            
        }
        

        
    }
    
    
    init(command: BTCommand, params: String? = nil) {
        self.command = command
        self.params = params
    }
    

    var description: String {
        if self.params == nil {
            return "\(userID)_\(command)"
        } else {
            return "\(userID)_\(command)_\(params!)"
        }
    }
    
    
    
}




