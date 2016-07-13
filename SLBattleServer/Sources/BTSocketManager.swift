//
//  SLSocketManager.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/1/16.
//
//

import PerfectLib

class BTSocketManager {
    
    static var sharedInstance = BTSocketManager()
    
    lazy var sockets = [BTSocket]()
    
    private init() {
        
    }
    
    
    func createSocket(socket: WebSocket, forKey key: String) -> BTSocket {
        let sock = BTSocket(sock: socket, forKey: key)
        sock.stateMachine = OCTStateMachine([BTSocketConnected(socket: sock),
                                             BTSocketMatching(socket: sock),
                                             BTSocketSynchronizing(socket: sock),
                                             BTSocketFighting(socket: sock),
                                             BTSocketEnding(socket: sock),
                                             BTSocketDisconnected(socket: sock)])
        let _ = sock.stateMachine.enterState(stateClass: BTSocketConnected.self)
        self.addSocket(sock)
        
        return sock
    }
    
    
    func addSocket(_ socket: BTSocket) {
        if hasSocket(socket) {
            return
        }
        
        self.sockets.append(socket)
    }
    
    
    func hasSocket(_ key: String) -> Bool {
        for sock in self.sockets {
            if sock.id == key {
                return true
            }
        }
        return false
    }
    
    
    func hasSocket(_ socket: BTSocket) -> Bool {
        return hasSocket(socket.id)
    }
    
    
    func findSocket(forKey key: String) -> BTSocket? {
        for sock in self.sockets {
            if sock.id == key {
                return sock
            }
        }
        
        return nil
    }
    
    
    func removeSocket(key: String) {
        self.sockets = self.sockets.filter {
            $0.id != key
        }
    }
    
    
    func checkDisconnectedSockets() {
        for sock in self.sockets {
            if !sock.isConnected {
                Logger.debug("sock: \(sock.id)")
                let _ = sock.stateMachine.enterState(stateClass: BTSocketDisconnected.self)
            }
        }
    }
    
    
    
//    func removeDisconnectedSockets() {
//        self.sockets = sockets.filter {
//            //zyh!! 以后换成Disconnected状态
//            $0.isConnected == true
//        }
//    }
    
    
//    func removeEndedSockets() {
//        self.sockets = self.sockets.filter {
//            !($0.stateMachine.currentState is BTSocketEnding)
//        }
//    }
    
    
//    func clear() {
//        removeEndedSockets()
//        removeDisconnectedSockets()
//    }
    
    
}



extension BTSocketManager {
    
    func matchingSockets() -> [BTSocket] {
        let ret = self.sockets.filter {
            $0.stateMachine.currentState is BTSocketMatching
        }
        return ret
    }
    
    
    func waitingForPeersSockets() -> [BTSocket] {
        return self.sockets.filter {
            $0.stateMachine.currentState is BTSocketSynchronizing
            
        }
    }
    
}












