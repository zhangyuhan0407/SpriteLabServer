//
//  BTBattleFieldManager.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/1/16.
//
//


import PerfectLib
import PerfectThread
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif





class BTBattleFieldManager {
    
    static var count: Int = 0
    
    static var sharedInstance = BTBattleFieldManager()
    
    private init() {
        self.startMatching()
        self.startClearInvalidBattleFields()
    }
    
    
    lazy var battleFields = [BTBattleField]()
    
    
    func addBattleField(battleField: BTBattleField) {
        if hasBattleField(key: battleField.id) {
            return
        }
        
        self.battleFields.append(battleField)
    }
    
    
    func findBattleField(key: String) -> BTBattleField? {
        
        for bf in battleFields {
            if bf.id == key {
                return bf
            }
        }
        Logger.debug("did not find battle field: \(key)")
        return nil
    }
    
    
    
    func hasBattleField(key: String) -> Bool {
        for field in self.battleFields {
            if field.id == key {
                return true
            }
        }
        return false
    }
    
    
    func nextBattleFieldID() -> String {
        BTBattleFieldManager.count += 1
        return "battlefield\(BTBattleFieldManager.count)"
    }
    
    
    
    func removeBattleField(key: String) {
        self.battleFields = battleFields.filter {
            $0.id != key
        }
    }
    
    
    func removeDisconnectedBattleFields() {
        self.battleFields = battleFields.filter {
            $0.status != .Disconnected
        }
    }
    
    
    func removeEndedBattleFields() {
        self.battleFields = battleFields.filter {
            $0.status != .End
        }
    }
    
    
    func removeInvalidBattleFields() {
        self.battleFields = battleFields.filter {
            if $0.isValid {
                return true
            }
            
            $0.handleDisconnected()
            return false
            
        }
    }
    
    
    func clearInvalidBattleFields() {
        
        removeInvalidBattleFields()
        removeDisconnectedBattleFields()
        removeEndedBattleFields()
    }
    
}




//MARK:- Matching Func


extension BTBattleFieldManager {
    
    
    private func startMatching() {
        Logger.info("start")
        Threading.dispatch {
            while true {
                self.matching()
                sleep(1)
            }
        }
    }
    
    
    private func matching() {
        let freeSockets = BTSocketManager.sharedInstance.matchingSockets()
        if freeSockets.count >= 2 {
            let newBattleField = BTBattleField(sockets: [freeSockets[0], freeSockets[1]])
            newBattleField.startFighting()
        }
    }
    
    
    private func startClearInvalidBattleFields() {
        Logger.info("start")
        Threading.dispatch {
            while true {
                self.clearInvalidBattleFields()
                sleep(10)
            }
        }
    }
    
    
}














