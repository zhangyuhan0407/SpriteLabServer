//
//  BTMessage.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/1/16.
//
//


import Foundation

#if os(iOS)
    let UserID = UserDefaults.standard().object(forKey: "userid") as! String
#else
    let UserID = "WebSocketServer"
#endif



public enum InitError: ErrorProtocol {
    case MessageInitError
}



public struct BTMessage: CustomStringConvertible {
    
    public var userid: String = UserID
    
    public var command: BTCommand
    
    public var params: [String: AnyObject]
    
    
    public init?(from string: String) {
        
        do {
            
            let json = try JSON.deserialize(string)
            
            guard let id = json["userid"].string else {
                return nil
            }
            
            
            guard let command = json["command"].string else {
                return nil
            }
            
            
            guard let params = json["params"].dictionaryObject else {
                return nil
            }
            
            
            self.userid = id
            self.command = BTCommand.decode(string: command)
            self.params = params
            
            
        } catch {
            return nil
        }
        
        
        
        
        
//        let strings = string.components(separatedBy: "_")
//        
//        if strings.count < 3 {
//            print(string)
//            return nil
//        }
//        
//        
//        self.userid = strings[0]
//        self.command = BTCommand.decode(string: strings[1])
//        self.params = strings[2]
        
        
    }
    
    
    public init(command: BTCommand, params: [String: AnyObject] = [:]) {
        self.userid = UserID
        self.command = command
        self.params = params
    }
    

    public var description: String {
        
        let dict: [String: AnyObject] = ["userid": self.userid, "command": self.command.description, "params": self.params]
        return JSON(dict).description
        
    }
    
    
    
}




