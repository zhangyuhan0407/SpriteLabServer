//
//  SLSocket.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/1/16.
//
//


import PerfectLib


enum BTPlayerStatus {
    case Connected
    case WaitingForPeers
    case Matching
    case Fighting
    case Win
    case Lose
    case Disconnected
}


class BTSocket {
    
    var id: String
    
    var socket: WebSocket
    
    var stateMachine: OCTStateMachine!
    
    weak var battleField: BTBattleField?
    
    var isInBattleField: Bool { return self.battleField == nil ? false : true }
    
    var isConnected: Bool { return self.socket.isConnected }
    
    
    //DO NOT CALL IT DIRECTLY
    init(sock: WebSocket, forKey key: String) {
        self.socket = sock
        self.id = key
        Logger.debug("socket: \(self.id)")
    }
    
    
    
    
//    func clear() {
//        Logger.info("socket: \(self.id)")
//        
//    }
    
    
    deinit {
        if self.isConnected {
            self.socket.close()
        }
        Logger.info("socket: \(self.id)")
    }
    
}











