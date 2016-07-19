//
//  BTNet.swift
//  SpriteLabClient
//
//  Created by yuhan zhang on 7/11/16.
//  Copyright © 2016 octopus. All rights reserved.
//


import Foundation
import Starscream


public protocol SLBattleFieldNetDelegate: NSObjectProtocol {
    func websocketDidConnected(socket: SLBattleFieldNet)
    func websocketDidDisconnected(_ socket: SLBattleFieldNet, error: NSError?)
    
//    func doStartFighting(msg: BTMessage)
//    func doEndFighting(msg: BTMessage)
//    func doPlayerDisconnected(msg: BTMessage)
//    func doCreateSpell(msg: BTMessage)
//    func doCastSpell(msg: BTMessage)
//    func doPlayerStatus(msg: BTMessage)
    
    
    func websocketDidReceiveMessage(msg: BTMessage, net: SLBattleFieldNet)
    
}



let BTWebSocketURL = ""
let BTProtocols = [""]



public class SLBattleFieldNet: WebSocketDelegate {
    
    let socket: WebSocket
    
    weak var delegate: SLBattleFieldNetDelegate?
    
    init(delegate: SLBattleFieldNetDelegate) {
        self.socket = WebSocket(url: URL(string: BTWebSocketURL)!, protocols: BTProtocols)
        self.socket.connect()
        self.socket.delegate = self
    }
    
    
    
    deinit {
        self.socket.disconnect()
        print("---------------web socket deinit")
    }
    
    
    
    
    public func websocketDidConnect(socket: WebSocket) {
        self.startHeartTick()
        self.delegate?.websocketDidConnected(socket: self)
    }
    
    
    
    public func websocketDidDisconnect(_ socket: WebSocket, error: NSError?) {
        self.delegate?.websocketDidDisconnected(self, error: error)
    }
    
    
    
    public func websocketDidReceiveData(_ socket: WebSocket, data: Data) {
        
    }
    
    
    
    public func websocketDidReceiveMessage(_ socket: WebSocket, text: String) {
        guard let msg = BTMessage(from: text) else {
            return
        }
        

        self.delegate?.websocketDidReceiveMessage(msg: msg, net: self)
//        switch msg.command {
//        case .SStartFighting:
//            self.delegate?.doStartFighting(msg: msg)
//        case .SEndFighting:
//            self.delegate?.doEndFighting(msg: msg)
//        case .SPlayerDisconnected:
//            self.delegate?.doPlayerDisconnected(msg: msg)
//        case .CCreateSpell:
//            self.delegate?.doCastSpell(msg: msg)
//        case .CCastSpell:
//            self.delegate?.doCastSpell(msg: msg)
//        case .CPlayerStatus:
//            self.delegate?.doPlayerStatus(msg: msg)
//        default:
//            print("unknow command: \(msg.command)")
//        }
        
    }
    
    
    
}



extension SLBattleFieldNet {
    func send(_ command: BTCommand, withParams params: [String: AnyObject]) {
        let msg = BTMessage(command: command, params: params)
        
        self.socket.write(string: msg.description)
    }
}













