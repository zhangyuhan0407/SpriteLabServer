//
//  BTTickControl.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/13/16.
//
//

import PerfectThread
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif




class BTTickControl {
    
    static func startTick() {
        Threading.dispatch {
            Logger.info("start")
//            while true {
                for sock in BTSocketManager.sharedInstance.sockets {
                    sock.socket.sendPing {
                        Logger.info("send ping to socket: \(sock.id)")
                    }
                }
            
//                sleep(2)
            
//            }
        }
        
        
    }
    
    
    
}



class BTLoop {
    static func start() {
        Threading.dispatch {
            while true {
                sleep(10)
                BTSocketManager.sharedInstance.removeEndingSockets()
                BTBattleFieldManager.sharedInstance.removeEndingBattleFields()
            }
        }
    }
}


extension BTBattleFieldManager {
    func removeEndingBattleFields() {
        self.battleFields = self.battleFields.filter {
            !($0.stateMachine.currentState is BTBattleFieldEnding)
        }
    }
}

extension BTSocketManager {
    func removeEndingSockets() {
        self.sockets = self.sockets.filter {
            !($0.stateMachine.currentState is BTSocketEnding)
        }
    }
}













