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
    
    
    var isConnected: Bool {
        return self.socket.isConnected
    }
    
    
    weak var battleField: BTBattleField?
    
//    var stateMachine: OCTStateMachine!
    
    
    var status: BTPlayerStatus = .Connected
//    {
//        //所有连接的Socket都默认需要开始匹配
//        return self.battleField?.status ?? .WaitForPeers
//    }
    
    
    //DO NOT CALL IT DIRECTLY
    init(sock: WebSocket, forKey key: String) {
        self.socket = sock
        self.id = key

        
        BTSocketManager.sharedInstance.addSocket(self)
    }
    
    
    
    
    
    func clear() {
        print("clear \(self.id)")
        self.socket.close()
    }
    
    
    deinit {
        clear()
    }
    
}











