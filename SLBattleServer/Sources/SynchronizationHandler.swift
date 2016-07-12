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
            Logger.debug("string: \(string), opcode: \(opcode), final: \(final)")
            
            
            if opcode == .invalid {
                socket.close()
                Logger.debug("Invalid Socket: \(socket.isConnected)")
                BTBattleFieldManager.sharedInstance.removeInvalidBattleFields()
                return
                
            } else if opcode == .close {
                socket.close()
                Logger.debug("Close Socket: \(socket.isConnected)")
                BTBattleFieldManager.sharedInstance.removeInvalidBattleFields()
                return
            }
            
            
            guard let s = string else {
                Logger.debug("empty string")
                self.handleSession(request: req, socket: socket)
                return
            }
            
            
            guard let msg = BTMessage(from: s) else {
                self.handleSession(request: req, socket: socket)
                return
            }
            
            
            
            let sock = BTSocketManager.sharedInstance.findSocket(forKey: msg.userID) ??
                        BTSocketManager.sharedInstance.createSocket(socket: socket, forKey: msg.userID)
            
            
            
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
        socket.status = .WaitingForPeers
        Logger.info("doMatch for socket: \(socket.id)")
    }
    
    
    func doMatch(msg: BTMessage, socket: BTSocket) {
//        let _ = socket.stateMachine.enterState(stateClass: BTSocketMatching.self)
        Logger.info("socket: \(socket.id)' status is \(socket.status)")
        if socket.status == .Connected {
            socket.status = .Matching
        }
        
    }
    
    
    func doStartFighting(msg: BTMessage, socket: BTSocket) {
        socket.battleField?.startFighting()
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
    
    
//    func doEndFighting(msg: BTMessage, socket: BTSocket) {
//        
//        if let bf = socket.battleField {
//            
//            let result = msg.params ?? "win"
//            
//            if result == "win" {
//                socket.status = .Win
//            } else if result == "lose" {
//                socket.status = .Lose
//            } 
//            
//            
//            for sock in bf.playerSockets {
//                if sock.status != .Win || sock.status != .Lose || sock.status != .Disconnected {
//                    return
//                }
//            }
//            bf.closeAllSockets()
//        }
//    }
    
    
    func doBattleResult(msg: BTMessage, socket: BTSocket) {
//        if let bf = socket.battleField {
        
            let result = msg.params ?? "win"
            
            if result == "win" {
                socket.status = .Win
            } else if result == "lose" {
                socket.status = .Lose
            }
            
//        }
    }
    
    
}
















