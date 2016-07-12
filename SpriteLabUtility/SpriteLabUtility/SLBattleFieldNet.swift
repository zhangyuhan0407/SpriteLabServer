//
//  BTNet.swift
//  SpriteLabClient
//
//  Created by yuhan zhang on 7/11/16.
//  Copyright © 2016 octopus. All rights reserved.
//


import Foundation
import Starscream


protocol SLBattleFieldNetDelegate: NSObjectProtocol {
    func doSynchronization(msg: BTMessage)
}


class SLBattleFieldNet: WebSocketDelegate {
    
    let socket: WebSocket
    
    weak var delegate: SLBattleFieldNetDelegate?
    
    init() {
        self.socket = WebSocket(url: URL(string: "")!, protocols: [""])
        self.socket.connect()
        self.socket.delegate = self
    }
    
    
    func websocketDidConnect(socket: WebSocket) {
        
    }
    
    func websocketDidDisconnect(_ socket: WebSocket, error: NSError?) {
        
    }
    
    func websocketDidReceiveData(_ socket: WebSocket, data: Data) {
        
    }
    
    func websocketDidReceiveMessage(_ socket: WebSocket, text: String) {
        guard let msg = BTMessage(from: text) else {
            print(text)
            return
        }
        
        switch msg.command {
        case .Synchronize:
            self.delegate?.doSynchronization(msg: msg)
        default:
            print("unknow command: \(msg.command)")
        }
        
    }
    
    
    
}
