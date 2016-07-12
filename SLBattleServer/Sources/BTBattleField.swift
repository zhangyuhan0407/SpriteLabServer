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


struct SocketKeys {
    let playerSocketKeys: [String]
    
    
}




class BTBattleField {
    
    let id: String
    
    let playerSocketKeys: [String]
    
    var playerSockets = [BTSocket]()
    
    
    
    
    
    var status = BattleFieldStatus.Waiting
//    {
//        didSet {
//            if status == BattleFieldStatus.End {
//                self.saveRecord()
//            }
//        }
//    }
    
    
    lazy var record = [(String, BTMessage)]()
    
    
    var isValid: Bool {
        for sock in self.playerSockets {
            if !sock.socket.isConnected {
                self.status = .Disconnected
                Logger.info("battle field: \(id) is NOT valid")
                return false
            }
        }
        Logger.info("battle field: \(id) is valid with \(self.playerSockets.count) players")
        return true
    }
    
    
    var isReady: Bool {
        Logger.debug("battle field playerSocketKeys: \(playerSocketKeys.count) playerSockets: \(playerSockets.count)")
        return self.playerSockets.count == self.playerSocketKeys.count
    }
    
    
    
    init(playerSocketKeys keys: [String]) {
        self.id = BTBattleFieldManager.sharedInstance.nextBattleFieldID()
        self.playerSocketKeys = keys
        
        BTBattleFieldManager.sharedInstance.addBattleField(battleField: self)
    }
    
    
    init(sockets: [BTSocket]) {
        self.id = BTBattleFieldManager.sharedInstance.nextBattleFieldID()
        self.playerSocketKeys = sockets.map { $0.id }
        
        for sock in sockets {
            self.addPlaySocket(socket: sock)
        }
        
        BTBattleFieldManager.sharedInstance.addBattleField(battleField: self)
    }
    
    
    
    func startFighting() {
        if self.status == . Waiting && self.isReady {
            self.status = .Fighting
            for sock in self.playerSockets {
                sock.status = .Fighting
            }
            broadcast(BTMessage(command: BTCommand.StartFighting))
        }
    }
    
    
    func endFighting() {
        if self.status == .Fighting {
            self.status = .End
            broadcast(BTMessage(command: BTCommand.EndFighting))
        }
    }
    
    
    func handleDisconnected() {
        self.status = .Disconnected
        self.broadcast(BTMessage(command: BTCommand.PlayerDisconnected))
    }
    
    
    
    
    func addPlaySocket(socket: BTSocket) {
        if hasPlayer(socket) {
            return
        }
        
        self.playerSockets.append(socket)
        socket.battleField = self
        
    }
    
    
    
    func hasPlayer(_ key: String) -> Bool {
        for playerSocket in self.playerSockets {
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
        self.saveRecord()
    }
    
}












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
    
    
    func recordMessage(msg: BTMessage) {
        self.record.append((Logger.localTime(), msg))
    }
    
    
    
    
    
    
    
    
    
    
    
    func broadcast(_ msg: BTMessage) {
        
        recordMessage(msg: msg)
        
        for sock in self.playerSockets {
            sock.socket.sendStringMessage(string: msg.description, final: true) {
                Logger.info("battle field: \(self.id) BROADCAST message: \(msg) to socket: \(sock.id)")
            }
        }
    }
    
    
    func forward(msg: BTMessage, fromPlayer playerID: String) {
        
        recordMessage(msg: msg)
        
        for sock in self.playerSockets {
            if sock.id != playerID {
                sock.socket.sendStringMessage(string: msg.description, final: true) {
                    Logger.info("battle field: \(self.id) FORWARD message: \(msg) to socket: \(sock.id)")
                }
            }
        }
    }
    
    
    func forward(msg: BTMessage, forPlayer sour: String, toPlayer dest: String) {
        
        recordMessage(msg: msg)
        
        for sock in self.playerSockets {
            if sock.id == dest {
                sock.socket.sendStringMessage(string: msg.description, final: true) {
                    Logger.info("battle field: \(self.id) FORWARD message: \(msg) to socket: \(sock.id)")
                }
            }
        }
    }
    
    
}

























