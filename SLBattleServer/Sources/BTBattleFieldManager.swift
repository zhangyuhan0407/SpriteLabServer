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
    }
    
    
    lazy var battleFields = [BTBattleField]()
    
    
    func createBattleField() -> BTBattleField {
        let newBattleField = BTBattleField(id: self.nextBattleFieldID())
        
        newBattleField.stateMachine = OCTStateMachine([BTBattleFieldSynchronizing(newBattleField),
                                                       BTBattleFieldFighting(newBattleField),
                                                       BTBattleFieldEnding(newBattleField),
                                                       BTBattleFieldDisconnected(newBattleField)
            ])
        let _ = newBattleField.stateMachine.enterState(stateClass: BTBattleFieldSynchronizing.self)
        
        self.addBattleField(battleField: newBattleField)
        
        return newBattleField
    }
    
    
    func createBattleField(forSockets sockets: [BTSocket]) -> BTBattleField {

        let newBattleField = self.createBattleField()
        
        for sock in sockets {
            newBattleField.addPlaySocket(socket: sock)
        }
        
        return newBattleField
        
    }
    
    
    
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
        return "BattleField_\(BTBattleFieldManager.count)"
    }
    
    
    func removeBattleField(key: String) {
        self.battleFields = battleFields.filter {
            return $0.id != key
        }
    }
    
    
//    func checkBattleFields() {
//        for bf in self.battleFields {
//            if !bf.isAllPlayersConnecting {
//                let _ = bf.stateMachine.enterState(stateClass: BTBattleFieldDisconnected.self)
//            }
//        }
//    }
    
    
//    func removeDisconnectedBattleFields() {
//        self.battleFields = battleFields.filter {
//            !($0.stateMachine.currentState is BTBattleFieldDisconnected)            
//        }
//    }
    
    
//    func removeEndedBattleFields() {
//        self.battleFields = battleFields.filter {
//            if $0.stateMachine.currentState is BTBattleFieldEnding {
////                for sock in $0.playerSockets {
////                    if sock.isConnected {
////                        sock.socket.close()
////                    }
////                }
//                Logger.info("battle field: \($0.id)")
//                return false
//            }
//            return true
//        }
//    }
//
//    
//    
//    func clearInvalidBattleFields() {
//        removeEndedBattleFields()
//    }
    
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
            let newBattleField = BTBattleFieldManager.sharedInstance.createBattleField(forSockets: [freeSockets[0], freeSockets[1]])
            let _ = newBattleField.stateMachine.enterState(stateClass: BTBattleFieldFighting.self)
        }
    }
    
    
    
}














