//
//  BTBattleField.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/1/16.
//
//

import PerfectLib
import Foundation


enum BattleFieldStatus {
    
    case Waiting
//    case Matching
    case Fighting
    case End
    case Disconnected
    
}


let BattleRecordDirPath = "\(WebRoot)/records"



class BTBattleField {
    
    let id: String 
    
    private var _playerSockets = [BTSocket]()
    
    var playerSockets: [BTSocket] {
        return self._playerSockets
    }
    
    
    var stateMachine: OCTStateMachine!
    
    
    lazy var record = [(String, BTMessage)]()

    
    init(id: String) {
        self.id = id
        Logger.debug("battle field: \(self.id)")
    }
    
    
    
    var isAllPlayersConnecting: Bool {
        for sock in self._playerSockets {
            if !sock.isConnected {
                return false
            }
        }
        return true
    }
    
    
    var isAllPlayerStateMatching: Bool {
        for sock in self._playerSockets {
            guard sock.stateMachine.currentState is BTSocketMatching else {
                return false
            }
        }
        return true && self._playerSockets.count == 2
    }
    
    
    var isAllPlayerStateSynchronizing: Bool {
        for sock in self._playerSockets {
            guard sock.stateMachine.currentState is BTSocketSynchronizing else {
                return false
            }
        }
        return true && self._playerSockets.count == 2
    }
    
    
    var isAllPlayerStateSynchronized: Bool {
        for sock in self._playerSockets {
            guard sock.stateMachine.currentState is BTSocketSynchronized else {
                return false
            }
        }
        return true && self._playerSockets.count == 2
    }
    
    
    var isAllPlayerStateFighting: Bool {
        for sock in self._playerSockets {
            guard sock.stateMachine.currentState is BTSocketFighting else {
                return false
            }
        }
        return true && self._playerSockets.count == 2
    }
    
    
    
    var isAllPlayerStateEnding: Bool {
        for sock in self._playerSockets {
            guard sock.stateMachine.currentState is BTSocketEnding else {
                return false
            }
        }
        return true
    }
    
    
    
    
    func addPlaySocket(socket: BTSocket) {
        if hasPlayer(socket) {
            return
        }
        
        self._playerSockets.append(socket)
        if socket.battleField != nil {
            Logger.error("battle field: \(socket.battleField!.id)")
        }
        socket.battleField = self
        
    }
    
    
    
    func hasPlayer(_ key: String) -> Bool {
        for playerSocket in self._playerSockets {
            if playerSocket.id == key {
                return true
            }
        }
        return false
    }
    
    
    
    func hasPlayer(_ socket: BTSocket) -> Bool {
        return hasPlayer(socket.id)
    }
    
    
    
    deinit {
        Logger.debug("battle field: \(self.id)")
        self.saveRecord()
    }
    
}



//MARK:- Record



extension BTBattleField {
    
    func recordToString() -> String {
        var s = ""
        for (time, msg) in self.record {
            s.append("\(time)---\(msg)\n")
        }
        return s
    }
    
    
    func saveRecord() {
        Logger.info("save Battle Field: \(self.id) record to file")
        let file = File(BattleRecordDirPath + "/" + self.id)
        if file.exists {
            Logger.debug("\(file) exists BUT SHOULD NOT EXIST")
            file.delete()
        }
        do {
            try file.open(File.OpenMode.write)
            
            let _ = try file.write(string: recordToString())
            
            file.close()
        } catch {
            Logger.error("Battle Field: \(self.id) save to file ERROR")
        }
        
    }
    
    
}




//MARK:- Broadcast
    
    
extension BTBattleField {
    
    func recordMessage(msg: BTMessage) {
        self.record.append((Logger.localTime(), msg))
    }
    
    
    func broadcast(_ msg: BTMessage) {
        
        recordMessage(msg: msg)
        
        for sock in self._playerSockets {
            sock.socket.sendStringMessage(string: msg.description, final: true) {
                Logger.info("battle field: \(self.id) BROADCAST message: \(msg) to socket: \(sock.id)")
            }
        }
    }
    
    
    func forward(msg: BTMessage, fromPlayer playerID: String) {
        
        recordMessage(msg: msg)
        
        for sock in self._playerSockets {
            if sock.id != playerID {
                sock.socket.sendStringMessage(string: msg.description, final: true) {
                    Logger.info("battle field: \(self.id) FORWARD message: \(msg) to socket: \(sock.id)")
                }
            }
        }
    }
    
    
    func forward(msg: BTMessage, forPlayer sour: String, toPlayer dest: String) {
        
        recordMessage(msg: msg)
        
        for sock in self._playerSockets {
            if sock.id == dest {
                sock.socket.sendStringMessage(string: msg.description, final: true) {
                    Logger.info("battle field: \(self.id) FORWARD message: \(msg) to socket: \(sock.id)")
                }
            }
        }
    }
    
    
}

























