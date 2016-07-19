//
//  BTBattleFieldState+Synchronizing.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation



class BTBattleFieldSynchronizing: BTBattleFieldState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is BTBattleFieldSynchronized.Type {
            if self.battleField!.isAllPlayerStateSynchronized {
                return true
            }
        } else if stateClass is BTBattleFieldDisconnected.Type {
            return true
        }
        
        return false
    }
    
    override func didEnterWithPreviousState(_ previousState: OCTState?) {
        super.didEnterWithPreviousState(previousState)
        
        
        for sock in self.battleField!.playerSockets {
            let _ = sock.stateMachine.enterState(stateClass: BTSocketSynchronizing.self)
        }
        
        self.battleField?.broadcast(BTMessage(command: BTCommand.SStartSynchronizing))
    }
}




class BTBattleFieldSynchronized: BTBattleFieldState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        if stateClass is BTBattleFieldFighting.Type {
//            if self.battleField!.isAllPlayerStateFighting {
                return true
//            }
        } else if stateClass is BTBattleFieldDisconnected.Type {
            return true
        }
        
        return false
        
    }
    
    
    
    override func didEnterWithPreviousState(_ previousState: OCTState?) {
        super.didEnterWithPreviousState(previousState)
        
        
        let _ = self.battleField?.stateMachine.enterState(stateClass: BTBattleFieldFighting.self)
        
    }
    
    
    
}










