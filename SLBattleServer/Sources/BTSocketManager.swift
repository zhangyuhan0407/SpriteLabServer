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
//        sock.stateMachine = OCTStateMachine([BTSocketConnected(socket: sock),
//                                             BTSocketMatching(socket: sock),
//                                             BTSOcketSynchronizing(socket: sock),
//                                             BTSocketFighting(socket: sock),
//                                             BTSocketEnding(socket: sock)])
        
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
        clear()
        
        for sock in self.sockets {
            if sock.id == key {
                Logger.info("find socket: \(key)")
                return sock
            }
        }
        
        Logger.info("did not find socket: \(key)")
        return nil
    }
    
    
    
    func removeDisconnectedSockets() {
        self.sockets = sockets.filter {
            $0.isConnected == true
        }
    }
    
    
    func removeEndedSockets() {
        self.sockets = self.sockets.filter {
            $0.status != .Win || $0.status != .Lose
        }
    }
    
    
    func clear() {
        removeEndedSockets()
        removeDisconnectedSockets()
    }
    
    
}



extension BTSocketManager {
    
    func matchingSockets() -> [BTSocket] {
        let ret = self.sockets.filter {
            $0.status == BTPlayerStatus.Matching
//            return true
        }
        return ret
    }
    
    
    func waitingForPeersSockets() -> [BTSocket] {
        return self.sockets.filter {
            $0.status == BTPlayerStatus.WaitingForPeers
        }
    }
}












