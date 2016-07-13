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
        
        
//        socket.readBytesMessage { (data, opcode, final) in
//            Logger.debug("data: \(data), opcode: \(opcode), final: \(final)")
//            
//            
//            if opcode == .pong {
//                print(String(bytes: data!, encoding: String.Encoding.utf8))
//                print("received pong")
//            } else if opcode == .close {
//                print(String(bytes: data!, encoding: String.Encoding.utf8))
//                print("received close")
//            }
//            
//            
//            self.handleSession(request: req, socket: socket)
//            
//            
//        }
        
        
        
        
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
            
            
            
            let sock = BTSocketManager.sharedInstance.findSocket(forKey: msg.userID) ??
                        BTSocketManager.sharedInstance.createSocket(socket: socket, forKey: msg.userID)
            
            
            Logger.debug("socket: \(sock.id) do command: \(msg.command)")
            
            switch msg.command {
            case .Synchronize:
                self.doSynchronize(msg: msg, socket: sock)
            case .Match:
                self.doMatch(msg: msg, socket: sock)
            case .StartFighting:
                self.doStartFighting(msg: msg, socket: sock)
            case .CreateSpell:
                self.doCreateSpell(msg: msg, socket: sock)
            case .CastSpell:
                self.doCastSpell(msg: msg, socket: sock)
            case .PlayerStatus:
                self.doPlayerStatus(msg: msg, socket: sock)
            case .BattleResult:
                self.doBattleResult(msg: msg, socket: sock)
            default:
                Logger.error("Unknow Command: \(msg.command)")
            }
            
            
            self.handleSession(request: req, socket: socket)
            
        }
        
        
    }
    
    
    func doSynchronize(msg: BTMessage, socket: BTSocket) {
        
        let bf = BTBattleFieldManager.sharedInstance.findBattleField(key: msg.params!) ??
                    BTBattleFieldManager.sharedInstance.createBattleField()
        
        
        bf.addPlaySocket(socket: socket)
        
        let _ = socket.stateMachine.enterState(stateClass: BTSocketSynchronizing.self)
    }
    
    
    func doMatch(msg: BTMessage, socket: BTSocket) {
        let _ = socket.stateMachine.enterState(stateClass: BTSocketMatching.self)
    }
    
    
    func doStartFighting(msg: BTMessage, socket: BTSocket) {
        let _ = socket.battleField?.stateMachine.enterState(stateClass: BTBattleFieldFighting.self)
    }
    
    
    func doCreateSpell(msg: BTMessage, socket: BTSocket) {
        socket.battleField?.forward(msg: msg, fromPlayer: msg.userID)
    }
    
    
    func doCastSpell(msg: BTMessage, socket: BTSocket) {
        socket.battleField?.forward(msg: msg, fromPlayer: msg.userID)
    }
    
    
    func doPlayerStatus(msg: BTMessage, socket: BTSocket) {
        socket.battleField?.forward(msg: msg, fromPlayer: msg.userID)
    }
    
    
    
    func doBattleResult(msg: BTMessage, socket: BTSocket) {

        let _ = socket.stateMachine.enterState(stateClass: BTSocketEnding.self)
        
        
        
//        
//        let result = msg.params ?? "win"
//        
//        if result == "win" {
//            
//        } else if result == "lose" {
//            let _ = socket.stateMachine.enterState(stateClass: BTSocketEnding.self)
//        }
        
    }
    
    
}
















