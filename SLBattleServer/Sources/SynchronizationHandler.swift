//
//  SynchronizationHandler.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 6/30/16.
//
//


import PerfectLib

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif


class SynchronizationHandler: WebSocketSessionHandler {
    
    let socketProtocol: String? = "SynchronizationHandler"
    
    func handleSession(request req: WebRequest, socket: WebSocket) {
        
        socket.readStringMessage { (string, opcode, final) in
//            Logger.debug("string: \(string), opcode: \(opcode), final: \(final)")
            
            if opcode == .invalid {
                socket.close()
                Logger.debug("Invalid Socket: \(socket.isConnected)")
                BTSocketManager.sharedInstance.checkDisconnectedSockets()
                return
                
            } else if opcode == .close {
                socket.close()
                Logger.debug("Close Socket: \(socket.isConnected)")
                BTSocketManager.sharedInstance.checkDisconnectedSockets()
                return
            } else if opcode == .ping{
                print("received ping")
                self.handleSession(request: req, socket: socket)
            }
            
            
            guard let s = string else {
                Logger.debug("empty string with opcode: \(opcode)")
                self.handleSession(request: req, socket: socket)
                return
            }
            
            
            guard let msg = BTMessage(from: s) else {
                self.handleSession(request: req, socket: socket)
                return
            }
            
            
            
            let sock = BTSocketManager.sharedInstance.findSocket(forKey: msg.userid) ??
                        BTSocketManager.sharedInstance.createSocket(socket: socket, forKey: msg.userid)
            
            
            Logger.debug("socket: \(sock.id) do command: \(msg.command)")
            
            switch msg.command {
                
            case .CStatusMatching:
                self.doStatusMatching(message: msg, socket: sock)
            case .CStatusSynchronized:
                self.doStatusSynchronized(message: msg, socket: sock)
//            case .CStatusFighting:
//                self.doStatusFighting(message: msg, socket: sock)
            case .CStatusEnding:
                self.doStatusEnding(message: msg, socket: sock)

                
            case .CCreateSpell:
                self.doCreateSpell(msg: msg, socket: sock)
            case .CCastSpell:
                self.doCastSpell(msg: msg, socket: sock)
            case .CPlayerStatus:
                self.doPlayerStatus(msg: msg, socket: sock)
                
            default:
                Logger.error("Unknow Command: \(msg.command)")
            }
            
            
            self.handleSession(request: req, socket: socket)
            
        }
        
        
    }
    
    
    
    func doStatusMatching(message: BTMessage, socket: BTSocket) {
        let _ = socket.stateMachine.enterState(stateClass: BTSocketMatching.self)
    }
    
    
    func doStatusSynchronized(message: BTMessage, socket: BTSocket) {
        let _ = socket.stateMachine.enterState(stateClass: BTSocketSynchronized.self)
    }
    
    
    func doStatusFighting(message: BTMessage, socket: BTSocket) {
        let _ = socket.stateMachine.enterState(stateClass: BTSocketFighting.self)
    }
    
    
    
    func doStatusEnding(message: BTMessage, socket: BTSocket) {
        let _ = socket.stateMachine.enterState(stateClass: BTSocketEnding.self)
    }
    
    
    
    func doCreateSpell(msg: BTMessage, socket: BTSocket) {
        socket.battleField?.forward(msg: msg, fromPlayer: msg.userid)
    }
    
    
    func doCastSpell(msg: BTMessage, socket: BTSocket) {
        socket.battleField?.forward(msg: msg, fromPlayer: msg.userid)
    }
    
    
    func doPlayerStatus(msg: BTMessage, socket: BTSocket) {
        socket.battleField?.forward(msg: msg, fromPlayer: msg.userid)
    }
    
    
    
}
















